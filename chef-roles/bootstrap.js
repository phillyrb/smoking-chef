{
  "users": {
      "erikh": { 
        "ssh_keys":  "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAs4VxyIlu5v0Wkx6RQvu5Eob0/UUFEpxFhmX/6SRH8dauIGF6rPbWRA3uVMk9Bsp/SVyGdiwZ6H1/pjjlqpk+9s74oXNFfBhRyzGfmy8Yzg+S+SrWT6YG96R+a42qYTPoqkJ8lqndMwfUXM1aVfjzi7yEuv2cQJQcci3Aaond1IMD7WeU5eKkESoTldh+4ZNsQ7YCP8+9EBA8BN1XnxGGIHA7xuwV3W69ojdYH/0+P48RpBKIcibTec9VDUbSmNUcddl+OEBy5aR4LSaYH5N6jE3i47KKTjY1KRhZUpavFGg3OKpKqNSzXuCJrxRPxuJC8j1Z/YCT6b+2cMSA7p3aJSN+gsLeVCMhB6h2oWhlapUsIlOQERvUwlYYYnluXeDYKDRCO5MXxjCWLcXADwYd/JepG3b4bTW01R+DuhkXUvwn7JlGB6cRJGQgMtj23KVTxgpLspsCGhRCR6nT40nNq2xkWZd9T2+BoHC5OzAs4Pc6tNLe/w8/mEJ8Bhp9BcYpfyW1NM5Qq08lVE0aKGCbwV68in47yZy6mWG+yn0Qz1P96dgWyOue1iS9IfHn5DgCxhj34E+JICrhHdRr3lQqOad3rH7oAYWpwl5qo0XPqdjx38lnv4VwtFPgllSAv3HPFV+CmdDacrYomJsjY1InCFJzYZ0j0+4M48UvJP3VkRU= erikh@islay",
        "groups":  ["sysadmin", "rvm"],
        "uid":  2001,
        "shell":  "\/bin\/bash",
        "comment":  "Erik Hollensbe"
      }
  },

  "authorization": {
    "sudo": { 
      "users": [ 
        "erikh"
      ]
    }
  },

  "run_list": [
    "recipe[users::sysadmins]",
    "recipe[sudo]",
    "recipe[rvm::ruby_192]"
  ]
}

// vim: ft=javascript et sts=2 sw=2 ts=2
