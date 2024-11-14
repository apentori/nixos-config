
let
  irotnep = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHb8ORNUIJkwUACMl59CvbqJJ2dFVL2QYDtJhAgehKRQSW87nU2GtAc/23ncC7BsDJMolAare3gDODpcfxlDcrHOG6O9FQmakEY0AMRO0Wk4uJHRCCPjxyYLoRUNKOUjmpY6JEG+ZzKjRGqMcvH19PmzUOkR2thdJBJ8tluXEk/UraFoSJUcA8dRxou2o9jdLtTPJIRyZNkhiRXrnD+8rD6a+VqM2JWqTqg/Mgj6EaZHyXcg2xAtXHEbVl5MIAbWPwCz2DjVNp52dEe3GyUFdlFr8Rp7TVPfA8qe+hbrs2V+ubdgEAFxQBfsSoY9UPjhdO8Yl3nhqNvXOKRTQ+EJLdlGobJUG2blrAyleyREomSixOIf6LM6HwdRxPz1QzGf8kKvqyIWtzR/s7xoV3ELLTzxyrUZF9yLrRYbdlqnxIKErb6lrwB3WUIAaT7ZQdJpRZvM5kNPg3Z2ZQZzs7SdQ/d3N4CYptr+mXHOze2cazE6DYyCshk9E4C70pBMejfaRM8RCjky6jDkODNKvu9sJXtKHyX7QceSnK83jPE/1taDLhOfFxezcqSNATtATENd8D6ulTTxflWU+cxfsCEoAUIaat5ORINYFsLlxdf3VUAKZNNmWiEB7cWKzdXbiRuqSpTAyuIxdFpFCe3GrM2R+LunsEmx/qWsDyhYjU0t7C7w== irotnep@proton.me";

  achilleus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHQgsDpKBD5VuSDUAMHoP7bPcyaqC8kPlBhhWMoGg5G root@achilleus";

  hyperion = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8v+syIBfmBB7PRskFq1RLG5nbH230Skz+sLNoNG+8E3C0zHoQnY/cShSa6G8GuS4TzRk4EPVf5rqloSmjvSwgN9aLHgmhrfiKb8MuGcmTHsOWB3ZdPBUA07ULsRVmd/DRo2Oxoy5h2Y/OVfU/cT1e6NqGAKb8+83TaYsVSgFldRBUlgoIfep87zWxo0/olCxGzmo3SqQpMTgzkZtPV3/jdniy0tUO83hbWuXsCF8nWvzlAAcTYM7EFMikqS70xm9nuxVJtUBUFb4BuzbX5tkANgf6GjelPdM6YkL9daskJ8vsOhtO2mPUHonqLmn80ocusCClRTgv9UVADgvQr8Opl9PKdhODikjEva0KO1T46Zejo920Iv90F6+0eVn3gC3HaGqBM5EKaZU+Px5RYLJluL3Uq/OCqnoiNcJzmA4i6bKoKo3C3YMdvhneo7h//eV0g0c0/I/jeL7rfkuOY4pTPFsV34z4VaeZYloT4WpAJc8F5xdCkPAn98YaY2D0G98sTdbqE59ydXHOhZhDQIvkb1AEZKCzlDOEbKmKXuTQzQP8wHZE3JgltdP+oN5KfU69mr3IQqE45ZskCpTohGew9+Q/UOSpxQaIhYO7TParcZw0j4nnWBrESqm3QfQc3hb4tXr91nOoli9L70R7EkxeTLAUdjJ3IBth4sm4jcWlKQ== root@hyperion";

  mnemosyme = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEMnKNpABJ24znkiHZu3+9Ehipc4Cr6T5iA+hyzA36Mm";

  systems = [ achilleus hyperion mnemosyme ];

  all = irotnep ++ systems;
in
{
  "services/geth/jwt-secret.age" = { publicKeys = [ irotnep hyperion ]; };
  "services/wifi/manoir.age" = { publicKeys = [ irotnep mnemosyme ]; };
  "services/nextcloud/admin.age" = { publicKeys = [ irotnep hyperion mnemosyme]; };
  "services/paperless/admin.age" = { publicKeys = [ irotnep hyperion mnemosyme]; };
}
