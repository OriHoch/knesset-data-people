FROM frictionlessdata/datapackage-pipelines
RUN pip install --no-cache-dir pipenv pew
RUN apk --update --no-cache add build-base python3-dev bash jq libxml2 libxml2-dev git libxslt libxslt-dev curl \
                                libpq postgresql-dev openssl
COPY Pipfile /pipelines/
COPY Pipfile.lock /pipelines/
RUN pipenv install --system --deploy --ignore-pipfile
RUN apk --update --no-cache add python &&\
    pip install psycopg2-binary &&\
    pip install --upgrade https://github.com/OriHoch/datapackage-pipelines/archive/cli-support-list-of-pipeline-ids.zip &&\
    pip install --upgrade https://github.com/OriHoch/knesset-data-pipelines/archive/add-missing-tables-from-knesset.zip &&\
    cd / && wget -q https://storage.googleapis.com/pub/gsutil.tar.gz && tar xfz gsutil.tar.gz && rm gsutil.tar.gz
COPY boto.config /root/.boto
COPY *.py /pipelines/
COPY pipeline-spec.yaml /pipelines/
COPY download/pipeline-spec.yaml /pipelines/download/
COPY *.sh /pipelines/
COPY join_mks_extra_details.yaml /pipelines/
ENTRYPOINT ["/pipelines/pipelines_script.sh"]
