import pytest
import time
import requests
import logging


logging.root.setLevel(logging.DEBUG)
logging.getLogger("urllib3").setLevel(logging.INFO)
logging.getLogger("selenium").setLevel(logging.INFO)


class SeleniumHubClient(object):
    URL = "http://selenium-hub:4444/grid/api/hub"

    def __init__(self):
        self.log = logging.getLogger("SeleniumHubClient")

    @property
    def available_slots(self):
        try:
            r = requests.get(self.URL)
        except Exception as ex:
            self.log.warning(f"Failed to fetch Selenium Hub status: {ex}")
            return -1

        if r.status_code != 200:
            self.log.warning(f"Received HTTP code={r.status_code}")
            return -1

        try:
            json = r.json()
            self.log.debug(f"Status response from Selenium HUB: {json}")
        except Exception as ex:
            self.log.warning(f"Failed to decode JSON from response: {ex}")
            return -1

        if json.get("success") is not True:
            self.log.warning(f"Selenium HUB not ready")
            return -1

        slots = r.json().get("slotCounts", {}).get("total", None)
        if slots is None:
            self.log.warning(f"Malformed Selenium HUB response, failed to extract number of slots available")
            return -1

        return slots


@pytest.fixture()
def selenium_hub_client() -> SeleniumHubClient:
    return SeleniumHubClient()


def wait_for_hub(selenium_hub_client: SeleniumHubClient, timeout):
    while timeout >= 0:
        if selenium_hub_client.available_slots > 0:
            break
        time.sleep(1)
        timeout -= 1


class TestSeleniumHubAvailability(object):
    def test_selenium_hub_availability(self, selenium_hub_client):
        wait_for_hub(selenium_hub_client, timeout=10)
        assert selenium_hub_client.available_slots > 0
