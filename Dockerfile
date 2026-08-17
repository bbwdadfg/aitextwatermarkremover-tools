FROM python:3.12-alpine
LABEL org.opencontainers.image.title="aitextwatermarkremover-tools"
LABEL org.opencontainers.image.description="Scan and remove invisible Unicode characters from text."
LABEL org.opencontainers.image.url="https://aitextwatermarkremover.com/"
LABEL org.opencontainers.image.source="https://github.com/bbwdadfg/aitextwatermarkremover-tools"
LABEL org.opencontainers.image.licenses="MIT"
COPY python/src/atwrtools /opt/atwr/python/src/atwrtools
COPY docker/atwr /usr/local/bin/atwr
RUN chmod +x /usr/local/bin/atwr
ENTRYPOINT ["atwr"]
CMD ["--help"]
