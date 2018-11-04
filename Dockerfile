FROM dockerpedia/pegasus_workflow_images:condor

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
	&& chmod +x /opt/montage/Montage_v3.3_patched_4/bin/

RUN mkdir -p things \
    && curl -SL https://raw.githubusercontent.com/rafaelfsilva/workflow-reproducibility/master/components/montage/montagedata.tar.gz \
    | tar -xzC  montage
