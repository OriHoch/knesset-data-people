FROM orihoch/sk8s-pipelines:v0.0.3-b

RUN pip install --no-cache-dir pipenv pew
RUN apk --update --no-cache add build-base python3-dev bash jq

COPY Pipfile /pipelines/
COPY Pipfile.lock /pipelines/
RUN pipenv install --system --deploy --ignore-pipfile && pipenv check
RUN apk add --update --no-cache libpq postgresql-dev openssl python && pip install psycopg2-binary

RUN cd / && wget -q https://storage.googleapis.com/pub/gsutil.tar.gz && tar xfz gsutil.tar.gz && rm gsutil.tar.gz
COPY boto.config /root/.boto

RUN pip install --upgrade https://github.com/OriHoch/datapackage-pipelines/archive/cli-support-list-of-pipeline-ids.zip

COPY --from=gcr.io/uumpa-public/sk8s-pipelines:v0.0.3 /entrypoint.sh /entrypoint.sh

COPY *.py /pipelines/
COPY pipeline-spec.yaml /pipelines/
COPY download/pipeline-spec.yaml /pipelines/download/
COPY *.sh /pipelines/
COPY join_mks_extra_details.yaml /pipelines/

ENV PIPELINES_SCRIPT="cd /pipelines && (source ./pipelines_script.sh)"
ENV RUN_PIPELINE_CMD=run_pipeline
