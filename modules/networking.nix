{
  # Network discovery, mDNS
  # With this enabled, you can access your machine at <hostname>.local
  # it's more convenient than using the IP address.
  # https://avahi.org/
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      domain = true;
      userServices = true;
    };
  };

  # Use an NTP server located in the mainland of Taiwan to synchronize the system time
  networking.timeServers = [
    "tick.stdtime.gov.tw"
    "tock.stdtime.gov.tw"
    "time.stdtime.gov.tw"
    "clock.stdtime.gov.tw"
    "watch.stdtime.gov.tw"
  ];
}
