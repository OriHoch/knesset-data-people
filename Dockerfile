FROM orihoch/sk8s-pipelines:v0.0.3-b

RUN pip install --no-cache-dir pipenv pew
RUN apk --update --no-cache add build-base python3-dev bash jq

COPY Pipfile /pipelines/
COPY Pipfile.lock /pipelines/
RUN pipenv install --system --deploy --ignore-pipfile && pipenv check

# temporary fix for dpp not returning correct exit code
# TODO: remove once datapackage-pipelines v1.5.4 is released
RUN pip install --upgrade https://github.com/OriHoch/datapackage-pipelines/archive/fix-exit-code.zip

COPY --from=gcr.io/uumpa-public/sk8s-pipelines:v0.0.3 /entrypoint.sh /entrypoint.sh

COPY *.py /pipelines/
COPY pipeline-spec.yaml /pipelines/
COPY download/pipeline-spec.yaml /pipelines/download/
COPY *.sh /pipelines/
COPY join_mks_extra_details.yaml /pipelines/

ENV PIPELINES_SCRIPT="cd /pipelines && (source ./pipelines_script.sh)"
ENV RUN_PIPELINE_CMD=run_pipeline
