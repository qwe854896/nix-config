{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    docker-compose
    dive # explore docker layers
    lazydocker # Docker terminal UI.
    skopeo # copy/sync images between registries and local storage
    go-containerregistry # provides `crane` & `gcrane`, it's similar to skopeo

    kubectl
    kubectx
    kubebuilder
    istioctl
    clusterctl # for kubernetes cluster-api
    kubevirt # virtctl
    kubernetes-helm
    fluxcd
    argocd

    ko # build go project to container image
  ];

  programs = {
    k9s = {
      enable = true;
    };
  };
}
