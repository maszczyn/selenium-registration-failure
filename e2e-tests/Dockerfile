FROM debian:stable

RUN cat /etc/apt/sources.list | sed 's/debian.org\/debian stable main/debian.org\/debian stable main non-free/g' > /etc/apt/sources.list.new && \
    mv /etc/apt/sources.list.new /etc/apt/sources.list

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip curl bzip2 && \
    apt-get clean

RUN pip3 install --upgrade pytest selenium requests

COPY install_firefox_and_geckodriver.sh /tmp/
RUN /tmp/install_firefox_and_geckodriver.sh && rm -f /tmp/install_firefox_and_geckodriver.sh

COPY *.py /tests/
WORKDIR /tests

CMD ["bash", "-c", "py.test"]
