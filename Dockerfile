
FROM lamw/vibauthor
ENV  OUTDIR=/output

# Download ghettoVCB VIB build script
ADD create_ghettoVCB_vib.sh /
RUN chmod +x /create_ghettoVCB_vib.sh

CMD ["/create_ghettoVCB_vib.sh"]
