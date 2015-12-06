#!/bin/sh
#
# Run like: sudo /usr/share/doc/mmap-lowmem/examples/divert-and-wrap-minetest.sh
#
set -e
echo This script will run:
echo
echo dpkg-divert --local --divert /usr/bin/minetest.minetest --rename --add /usr/bin/minetest
echo
echo ... and then install a wrapper script as /usr/bin/minetest
echo
echo Undo this by hand with:
echo
echo sudo rm /usr/bin/minetest
echo sudo dpkg-divert --local --divert /usr/bin/minetest.minetest --rename --remove /usr/bin/minetest
echo
echo Press enter to begin, C-c to abort.
read

dpkg-divert --local --divert /usr/bin/minetest.minetest --rename --add /usr/bin/minetest

cat > /usr/bin/minetest <<EOF
#!/bin/sh
LD_PRELOAD="$LD_PRELOAD /usr/lib/libmmap_lowmem_mt.so"
export LD_PRELOAD
exec /usr/bin/minetest.minetest "$@"
EOF

chmod +x /usr/bin/minetest
