FROM dockerpedia/pegasus_workflow_images:condor

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Montage" \
      org.label-schema.description="The Montage workflow was created by the NASA Infrared Processing and Analysis Center (IPAC) as an open source toolkit that can be used to generate custom mosaics of astronomical images in the Flexible Image Transport System (FITS) format" \
      org.label-schema.url="http://montage.ipac.caltech.edu/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/dockerpedia/montage" \
      org.label-schema.vendor="DockerPedia" \
      org.label-schema.version="1.0" \
      org.label-schema.schema-version="1.0"

WORKDIR /home/workflow
USER root
RUN apt-get update && apt-get install -y \
	curl \
    && rm -rf /var/lib/apt/lists/*
USER workflow
RUN mkdir -p /opt/montage/Montage_v3.3_patched_4/bin/ \
	&& cd /opt/montage/Montage_v3.3_patched_4/bin/ \
	&& wget "https://raw.githubusercontent.com/rafaelfsilva/workflow-reproducibility/master/components/montage/montagebins/mFitplane" \
	&& wget "https://raw.githubusercontent.com/rafaelfsilva/workflow-reproducibility/master/components/montage/montagebins/mDiff" \
	&& wget "https://raw.githubusercontent.com/rafaelfsilva/workflow-reproducibility/master/components/montage/montagebins/mDiffFit" \
	&& wget "https://raw.githubusercontent.com/rafaelfsilva/workflow-reproducibility/master/components/montage/montagebins/mConcatFit" \
	&& wget "https://raw.githubusercontent.com/rafaelfsilva/workflow-reproducibility/master/components/montage/montagebins/mImgtbl" \
	&& wget "https://raw.githubusercontent.com/rafaelfsilva/workflow-reproducibility/master/components/montage/montagebins/mShrink" \
	&& wget "https://raw.githubusercontent.com/rafaelfsilva/workflow-reproducibility/master/components/montage/montagebins/mProjectPP" \
	&& wget "https://raw.githubusercontent.com/rafaelfsilva/workflow-reproducibility/master/components/montage/montagebins/mAdd" \
	&& wget "https://raw.githubusercontent.com/rafaelfsilva/workflow-reproducibility/master/components/montage/montagebins/mBackground"   \
	&& wget "https://raw.githubusercontent.com/rafaelfsilva/workflow-reproducibility/master/components/montage/montagebins/mBgModel" \
	&& wget "https://raw.githubusercontent.com/rafaelfsilva/workflow-reproducibility/master/components/montage/montagebins/mJPEG" \
	&& chmod +x /opt/montage/Montage_v3.3_patched_4/bin/*

RUN curl -SL https://raw.githubusercontent.com/rafaelfsilva/workflow-reproducibility/master/components/montage/montagedata.tar.gz \
    | tar -xzC  .

ADD workflow.sh .
USER root
