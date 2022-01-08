import subprocess


def run_broker():
    print("starting broker")
    subprocess.call(["C:\Program Files\mosquitto\mosquitto", "-c", "C:\Program Files\mosquitto\mosquitto.conf"])


if __name__ == "__main__":
    run_broker()