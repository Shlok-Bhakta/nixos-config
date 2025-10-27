{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Shlok Bhakta";
    userEmail = "shlokbhakta1@gmail.com";
    lfs.enable = true;
  };

  programs.git-credential-oauth = {
    enable = true;
  };
}
