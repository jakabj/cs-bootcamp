namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.37
    - username: root
    - password: admin@123
    - filename: /tmp/deploy_war.sh
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 466
        y: 235
        navigate:
          fa529476-bb27-82d5-d9e9-32f83e85fa7c:
            targetId: 520c2b83-8355-1f8c-bb75-c2ad2880ff38
            port: SUCCESS
    results:
      SUCCESS:
        520c2b83-8355-1f8c-bb75-c2ad2880ff38:
          x: 637
          y: 245
