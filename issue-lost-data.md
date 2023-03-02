# Loss data issue !

    * in some scenario, the mounted folder is completely removed

## Related issues

    * https://github.com/vieux/docker-volume-sshfs/issues/81
    * https://github.com/fentas/docker-volume-davfs/issues/6

    * idea from : https://github.com/fentas/docker-volume-davfs/issues/6#issuecomment-1406673459
        * two volumes on same mountoint, one used, and mountpoint actively readed/write => when delete second volume => loss data ?
    * idea from : https://github.com/vieux/docker-volume-sshfs/issues/81#issuecomment-1063640681 
        * os.RemoveAll is too long ?

    * inspiration for fixing issue : https://github.com/ucphhpc/docker-volume-sshfs