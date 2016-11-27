
FROM lamw/vibauthor

# Download ghettoVCB VIB build script
RUN curl -O https://raw.githubusercontent.com/lamw/vghetto-scripts/master/shell/create_ghettoVCB_vib.sh && chmod +x create_ghettoVCB_vib.sh

# Run ghettoVCB VIB build script
RUN /root/create_ghettoVCB_vib.sh

CMD ["/bin/bash"]
