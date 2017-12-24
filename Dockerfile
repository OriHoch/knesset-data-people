FROM frictionlessdata/datapackage-pipelines

RUN pip install --no-cache-dir pipenv pew
RUN apk --update --no-cache add build-base python3-dev bash jq libxml2 libxml2-dev git libxslt libxslt-dev

COPY Pipfile /pipelines/
COPY Pipfile.lock /pipelines/
RUN pipenv install --system --deploy --ignore-pipfile && pipenv check

#COPY setup.py /pipelines/
#RUN pip install -e .

# temporary fix for dpp not returning correct exit code
# TODO: remove once this PR is merged: https://github.com/frictionlessdata/datapackage-pipelines/pull/107
RUN pip install --upgrade https://github.com/OriHoch/datapackage-pipelines/archive/fix-exit-code.zip

COPY download/pipeline-spec.yaml /pipelines/download/

RUN dpp run ./download/committees && dpp run ./download/members
RUN mv data / &&\
    echo "#!/usr/bin/env bash" > /copy_data.sh &&\
    echo "mkdir -p /pipelines/data" >> /copy_data.sh &&\
    echo "([ -e /pipelines/data/committees ] || cp -r /data/committees /pipelines/data/committees) && " >> /copy_data.sh &&\
    echo "([ -e /pipelines/data/members ] || cp -r /data/members /pipelines/data/members)" >> /copy_data.sh &&\
    chmod +x /copy_data.sh &&\
    echo "#!/usr/bin/env bash" > /docker_run.sh &&\
    echo "/copy_data.sh && /dpp/docker/run.sh "'$@' >> /docker_run.sh &&\
    chmod +x /docker_run.sh

COPY pipeline-spec.yaml /pipelines/
COPY *.py /pipelines/

ENTRYPOINT ["/docker_run.sh"]
