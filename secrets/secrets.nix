
let
  irotnep = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHb8ORNUIJkwUACMl59CvbqJJ2dFVL2QYDtJhAgehKRQSW87nU2GtAc/23ncC7BsDJMolAare3gDODpcfxlDcrHOG6O9FQmakEY0AMRO0Wk4uJHRCCPjxyYLoRUNKOUjmpY6JEG+ZzKjRGqMcvH19PmzUOkR2thdJBJ8tluXEk/UraFoSJUcA8dRxou2o9jdLtTPJIRyZNkhiRXrnD+8rD6a+VqM2JWqTqg/Mgj6EaZHyXcg2xAtXHEbVl5MIAbWPwCz2DjVNp52dEe3GyUFdlFr8Rp7TVPfA8qe+hbrs2V+ubdgEAFxQBfsSoY9UPjhdO8Yl3nhqNvXOKRTQ+EJLdlGobJUG2blrAyleyREomSixOIf6LM6HwdRxPz1QzGf8kKvqyIWtzR/s7xoV3ELLTzxyrUZF9yLrRYbdlqnxIKErb6lrwB3WUIAaT7ZQdJpRZvM5kNPg3Z2ZQZzs7SdQ/d3N4CYptr+mXHOze2cazE6DYyCshk9E4C70pBMejfaRM8RCjky6jDkODNKvu9sJXtKHyX7QceSnK83jPE/1taDLhOfFxezcqSNATtATENd8D6ulTTxflWU+cxfsCEoAUIaat5ORINYFsLlxdf3VUAKZNNmWiEB7cWKzdXbiRuqSpTAyuIxdFpFCe3GrM2R+LunsEmx/qWsDyhYjU0t7C7w== irotnep@proton.me";

  achilleus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHQgsDpKBD5VuSDUAMHoP7bPcyaqC8kPlBhhWMoGg5G root@achilleus";

  hyperion = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWi+ikWFuM0DcvydsKw4O+Qy6YW9i6pHZMD4jvc2KcNAqPDsOcE3KwOBJ1uxXlKFYS9aMkOh74FHHdUTLgSgpzqcP0a3lqsUKJ/dJPD4l+viC/5S9W6Dt/5sDoxFFXBc3s+IzHrnVxlepoJ0SNobISiuh1nEtPq8pC7AECGLAw+sfR69zChpSeiiJsGZ+XtextmSQhjabrnlJHF7PrZYZYzYBtG1BPKE+RXs+vzsxk9ZgfC414G0Ufja1kB0KtCtqoNbz6eAyhwL0uPZooXUaM6pAQ1DO6p9TXGp2TIBYc50JiOJ4btMFhmwgPvO1ub1my+M24yl+WTbYv51Ys36E3zr7SfSuafsLVMwZQAg32tyEGgi3TylV5e4ZqbKP88zuP9R6H9PKOESpmudn9IKyQ4MTFkG0wwLHQOQQV1FEilXdLZloAQVsUsyAKx+rKbLDheyYgPVMnhwkVca1Z7it5DyPD716bWQ3BCpoU9GdJSzXJGtPGo86whVWrjhotR1c8p36tsBghDi7cLpAwSz1OJg3L9KBeQcJ+Qz2Ebb19s0lMn5ZsH8HjzJWom506d3zGRNRp9J9vb1b6+3RN9nKrEr0KbSS3gxhmrGd9X9GJsCZuvaJOcjNW8OTsHAQb7rdxzRkR/PmUPpbxOr/GlUnZXJ1sXkHlL2pot/TID22RPQ== root@hyperion";

  mnemosyme = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEMnKNpABJ24znkiHZu3+9Ehipc4Cr6T5iA+hyzA36Mm";

  systems = [ achilleus hyperion mnemosyme ];

  all = irotnep ++ systems;
in
{
  "services/geth/jwt-secret.age" = { publicKeys = [ irotnep hyperion ]; };
  "services/wifi/manoir.age" = { publicKeys = [ irotnep achilleus mnemosyme ]; };
  "services/nextcloud/admin.age" = { publicKeys = [ irotnep hyperion achilleus ]; };
  "services/paperless/admin.age" = { publicKeys = [ irotnep hyperion achilleus ]; };
  "services/ghostfolio/env.age" = { publicKeys = [ irotnep hyperion achilleus ]; };
  "services/tandoor/secret-key.age" = { publicKeys = [ irotnep hyperion achilleus ]; };
}
