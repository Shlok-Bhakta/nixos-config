{ ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings.user = {
      name = "Shlok Bhakta";
      email = "shlokbhakta1@gmail.com";
    };
  };

  programs.git-credential-oauth = {
    enable = true;
  };
}
