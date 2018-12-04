namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host: 10.0.46.37
    - username: root
    - password: admin@123
    - url: "${get_sp('script_location')}"
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        publish: []
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: "${get_sp('script_location')}"
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - filename: '${filename}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename:
        x: 305
        y: 164
      remote_secure_copy:
        x: 845
        y: 176
        navigate:
          88dc245b-6289-71b6-2bde-9a38c55bbd94:
            targetId: 672c6dd4-0f8d-baae-7b3a-01ef6e44be62
            port: SUCCESS
      get_file:
        x: 550
        y: 162
    results:
      SUCCESS:
        672c6dd4-0f8d-baae-7b3a-01ef6e44be62:
          x: 1018
          y: 172
