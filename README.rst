Linux info sh & etc
===================

**inotify-tools** 
    Linux kernel subsystem, which monitors changes to the filesystem, and report those changes.

        *This code filtered output messages, excluding the folder '_build' and vims '.swp', '.swx' files:*
        ::

            inotifywait -mr ./ --exclude '_build|(.*\.sw.)' -e close_write -e create -e delete -e move
        
        *More complex example with group event by time:*

        ::

            inotifywait -mr source --exclude _build -e close_write -e create -e delete -e move --format '%w %e %T' --timefmt '%H%M%S' |
            while read file event tm; do
                current=$(date +'%H%M%S')
                delta=`expr $current - $tm`
                if [ $delta -lt 2 -a $delta -gt -2 ] ; then
                    sleep 1
                    make html singlehtml
                    xdotool search --name Chromium key --window %@ F5
                fi
            done

.. **util**
..     descr
.. 
..         *example*
..         ::
.. 
..             utiluse
