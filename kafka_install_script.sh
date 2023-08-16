#!/bin/sudo bash

install_kafka() {
  if ! wget "https://archive.apache.org/dist/kafka/$version/kafka_2.13-$version.tgz"; then
    echo "Kafka version $version not found."
    exit 1
  fi
  echo "Installing Kafka $version ..."
  tar -xvzf kafka_2.13-$version.tgz
  mv kafka_2.13-$version /opt/kafka
  echo "Kafka installed successfully."
}

uninstall_kafka() {
  echo "Uninstalling Kafka..."
  rm -rf /opt/kafka
  echo "Kafka uninstalled successfully."
}

check_kafka() {
  [ -d "/opt/kafka" ]
}

# Main script

action="$1"
version="$2"

if [ -z "$action" ]; then
  echo "No action provided. Use: $0 [install|uninstall]"
  exit 1
fi

case "$action" in
  install)
  
    if [ -z "$version" ]; then
      echo "No Kafka version provided. Use: $0 install [version]"
      exit 1
    fi
    
    check_kafka
    if check_kafka; then
      echo "Kafka is already installed."
    else
      install_kafka
    fi
    ;;
  uninstall)
    check_kafka
    if check_kafka; then
      uninstall_kafka
    else
      echo "Kafka is not installed."
    fi
    ;;
  *)
    echo "Invalid action. Use: $0 [install|uninstall]"
    exit 1
    ;;
esac
