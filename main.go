package main

import (
	"crypto/md5"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"sync"

	log "github.com/Sirupsen/logrus"
	"github.com/docker/go-plugins-helpers/volume"
	version_pkg "github.com/StudioEtrange/docker-volume-bindfs/version"
)

const socketAddress = "/run/docker/plugins/bindfs.sock"

const (
	// VolumeDirMode sets the permissions for the volume directory
	//VolumeDirMode = 0755
	VolumeDirMode = 0700
	// VolumeFileMode sets permissions for the volume files
	//VolumeFileMode = 0644
	VolumeFileMode = 0600
)

type bindfsVolume struct {
	Options     []string
	Sourcepath  string
	Mountpoint  string
	connections int
}

type bindfsDriver struct {
	mutex      *sync.Mutex
	volumes    map[string]*bindfsVolume
	volumePath string
	statePath  string
}

func newBindfsDriver(basePath string) (*bindfsDriver, error) {
	log.Infof("Creating a new driver instance %s", basePath)

	volumePath := filepath.Join(basePath, "volumes")
	statePath := filepath.Join(basePath, "state", "bindfs-state-" + version_pkg.Version + ".json")

	if verr := os.MkdirAll(volumePath, VolumeDirMode); verr != nil {
		return nil, verr
	}

	log.Infof("Initialized driver, volumes='%s' state='%s", volumePath, statePath)


	driver := &bindfsDriver{
		volumes:   map[string]*bindfsVolume{},
		volumePath: volumePath,
		statePath: statePath,
		mutex:      &sync.Mutex{},
	}

	data, err := ioutil.ReadFile(driver.statePath)
	if err != nil {
		if os.IsNotExist(err) {
			log.Debugf("No state file found at %s", driver.statePath)
		} else {
			return nil, err
		}
	} else {
		if err := json.Unmarshal(data, &driver.volumes); err != nil {
			return nil, err
		}
	}
	return driver, nil
}

func (d *bindfsDriver) saveState() {
	data, err := json.Marshal(d.volumes)
	if err != nil {
		log.Errorf("saveState file failed %s", err)
		return
	}

	if err := ioutil.WriteFile(d.statePath, data, VolumeFileMode); err != nil {
		log.Errorf("Failed to write file state %s to %s (%s)", data, d.statePath, err)
	}
}

// Driver API
func (d *bindfsDriver) Create(r *volume.CreateRequest) error {
	log.Debugf("Create Request %s", r)
	d.mutex.Lock()
	defer d.mutex.Unlock()

	v := &bindfsVolume{}
	for key, val := range r.Options {
		switch key {
			case "sourcePath":
				v.Sourcepath = val
			default:
				if val != "" {
					v.Options = append(v.Options, key+"="+val)
				} else {
					v.Options = append(v.Options, key)
				}
		}
	}

	if v.Sourcepath == "" {
		msg := fmt.Sprintf("'sourcePath' option required for volume %s", r.Name)
		log.Error(msg)
		return fmt.Errorf(msg)
	}
	v.Mountpoint = filepath.Join(d.volumePath, fmt.Sprintf("%x%x", md5.Sum([]byte(r.Name)),md5.Sum([]byte(v.Sourcepath))))
	v.connections = 0

	d.volumes[r.Name] = v
	d.saveState()
	return nil
}

func (d *bindfsDriver) List() (*volume.ListResponse, error) {
	log.Debugf("List Request")

	var vols []*volume.Volume
	for name, v := range d.volumes {
		vols = append(vols, 
			&volume.Volume{Name: name, Mountpoint: v.Mountpoint})
	}
	return &volume.ListResponse{Volumes: vols}, nil
}

func (d *bindfsDriver) Get(r *volume.GetRequest) (*volume.GetResponse, error) {
	log.Debugf("Get Request %s", r)

	v, ok := d.volumes[r.Name]
	if !ok {
		msg := fmt.Sprintf("Failed to get volume %s because it doesn't exists", r.Name)
		log.Debug(msg)
		return &volume.GetResponse{}, fmt.Errorf(msg)
	}

	return &volume.GetResponse{Volume: &volume.Volume{Name: r.Name, Mountpoint: v.Mountpoint}}, nil
}

func (d *bindfsDriver) Remove(r *volume.RemoveRequest) error {
	log.Debugf("Remove Request %s", r)
	d.mutex.Lock()
	defer d.mutex.Unlock()

	v, ok := d.volumes[r.Name]
	if !ok {
		msg := fmt.Sprintf("Failed to remove volume %s because it doesn't exists", r.Name)
		log.Error(msg)
		return fmt.Errorf(msg)
	}

	msg := fmt.Sprintf("calling os.RemoveAll method on mountpoint folder %s which was mapped to folder %s for volume named %s",v.Mountpoint, v.Sourcepath, r.Name )
	log.Debugf(msg)

	if v.connections > 0 {
		msg := fmt.Sprintf("Can't remove volume %s because it is mounted by %d containers", r.Name, v.connections)
		log.Error(msg)
		return fmt.Errorf(msg)
	}

	if err := d.removeVolume(v); err != nil {
		return err
	}

	delete(d.volumes, r.Name)
	d.saveState()
	return nil
}

func (d *bindfsDriver) Path(r *volume.PathRequest) (*volume.PathResponse, error) {
	log.Debugf("Path Request %s", r)
	v, ok := d.volumes[r.Name]
	if !ok {
		msg := fmt.Sprintf("Failed to find path for volume %s because volume doesn't exists", r.Name)
		log.Error(msg)
		return &volume.PathResponse{}, fmt.Errorf(msg)
	}

	return &volume.PathResponse{Mountpoint: v.Mountpoint}, nil
}

func (d *bindfsDriver) Mount(r *volume.MountRequest) (*volume.MountResponse, error) {
	log.Debugf("Mount Request %s", r)
	d.mutex.Lock()
	defer d.mutex.Unlock()

	v, ok := d.volumes[r.Name]
	if !ok {
		msg := fmt.Sprintf("Failed to mount volume %s because volume doesn't exists", r.Name)
		log.Error(msg)
		return &volume.MountResponse{}, fmt.Errorf(msg)
	}

	
	if v.connections == 0 {

		fi, err := os.Lstat(v.Mountpoint)
		if os.IsNotExist(err) {
			if err := os.MkdirAll(v.Mountpoint, VolumeDirMode); err != nil {
				msg := fmt.Sprintf("Error MkdirAll for %s, %s", r.Name, err)
				log.Error(msg)
				return &volume.MountResponse{}, fmt.Errorf(msg)
			}
		} else if err != nil {
			msg := fmt.Sprintf("Error %s, %s", r.Name, err)
			log.Error(msg)
			return &volume.MountResponse{}, fmt.Errorf(msg)
		}

		if fi != nil && !fi.IsDir() {
			msg := fmt.Sprintf("%v already exist and it's not a directory", v.Mountpoint)
			log.Error(msg)
			return &volume.MountResponse{}, fmt.Errorf(msg)
		}



		if err := d.mountVolume(v); err != nil {
			msg := fmt.Sprintf("Failed to mount %s, %s", r.Name, err)
			log.Error(msg)
			return &volume.MountResponse{}, fmt.Errorf(msg)
		}
	}
	v.connections++
	d.saveState()
	return &volume.MountResponse{Mountpoint: v.Mountpoint}, nil
}

func (d *bindfsDriver) Unmount(r *volume.UnmountRequest) error {
	log.Debugf("Umount Request %s", r)
	d.mutex.Lock()
	defer d.mutex.Unlock()

	v, ok := d.volumes[r.Name]
	if !ok {
		msg := fmt.Sprintf("Failed to unmount volume %s because it doesn't exists", r.Name)
		log.Error(msg)
		return fmt.Errorf(msg)
	}

	v.connections--
	if v.connections <= 0 {
		if err := d.unmountVolume(v); err != nil {
			return err
		}
		v.connections = 0
	}
	d.saveState()
	return nil
}

func (d *bindfsDriver) Capabilities() *volume.CapabilitiesResponse {
	log.Debugf("Capabilities Request")
	return &volume.CapabilitiesResponse{Capabilities: volume.Capability{Scope: "local"}}
}


// Helper methods ---------------------------------------------------

func (d *bindfsDriver) removeVolume(v *bindfsVolume) error {
	log.Debugf("removeVolume %#v", v)
	// Remove MountPoint

	// https://github.com/vieux/docker-volume-sshfs/commit/e9c9710a9a7c049cd92a1facd442e53cf5dbc459
	// Use os.remove instead of os.RemoveAll to ensure ensure that after unmount no files exists in the mountpoint
	// https://pkg.go.dev/os@go1.20.1#Remove
	// Remove removes the named file or (empty) directory. If there is an error, it will be of type *PathError.


	// if err := os.RemoveAll(v.Mountpoint); err != nil {
	// 	msg := fmt.Sprintf("error when calling os.RemoveAll method on mountpoint folder %s which was mapped to folder %s",v.Mountpoint, v.Sourcepath,)
	//	log.Error(msg)
	//	return fmt.Errorf(msg)
	// }


	// If the Mountpoint directory exist, remove it
	if _, err := os.Stat(v.Mountpoint); !os.IsNotExist(err) {
		// Else remove everything in that mountpoint
		if err := os.Remove(v.Mountpoint); err != nil {
			// If the mount is not mounted, remove legacy
			msg := fmt.Sprintf("Failed to remove the volume with sourcePath mountpoint %s (%s)", v.Sourcepath, v.Mountpoint, err)
			log.Error(msg)
			return fmt.Errorf(msg)
		}
	}
	return nil
}

func (d *bindfsDriver) mountVolume(v *bindfsVolume) error {
	log.Debugf("mountVolume %#v", v)
	cmd := exec.Command("bindfs", "/mnt/host" + v.Sourcepath, v.Mountpoint)

	for _, option := range v.Options {
		cmd.Args = append(cmd.Args, "-o", option)
	}


	log.Debugf("Executing mount command %v", cmd)
	log.Debug(cmd.Args)

	output, err := cmd.CombinedOutput()
	if err != nil {
		return fmt.Errorf("bindfs command failed %v %v (%s)", cmd, err, output)
	}
	return nil
}


func (d *bindfsDriver) unmountVolume(v *bindfsVolume) error {
	log.Debugf("unmountVolume %#v", v)

	cmd := fmt.Sprintf("umount %s", v.Mountpoint)
	log.Debugf("Executing umount command %v", cmd)
	if err := exec.Command("sh", "-c", cmd).Run(); err != nil {
		return err
	}

	// Check that the mountpoint is empty
	files, err := ioutil.ReadDir(v.Mountpoint)
	if err != nil {
		return err
	}

	if len(files) > 0 {
		return fmt.Errorf("after unmount %d files still exists in %s", len(files), v.Mountpoint)
	}

	return nil

}


// Main ---------------------------------------------------
func main() {
	debug := os.Getenv("DEBUG")
	if ok, _ := strconv.ParseBool(debug); ok {
		log.SetLevel(log.DebugLevel)
	}

	d, err := newBindfsDriver("/mnt")
	if err != nil {
		log.Fatal(err)
	}
	h := volume.NewHandler(d)
	log.Infof("plugin bindfs listening on %s", socketAddress)
	log.Error(h.ServeUnix(socketAddress, 0))
}
