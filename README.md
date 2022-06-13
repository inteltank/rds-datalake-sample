

# 概要
RDS snapshotからDatalakeを作るための仕組みのdemo
RDS to datalakeの仕組みはEventBridgeとLambdaでsimpleに作成できるが、
「そもそもdatabaseが組み立てられたRDSを用意する」のが複雑で、architectureが複雑になっている。
通信/security周りの最低限の仕組みも作っているため、「どうしてこういう構成なのか」を後述する

![aws architecture](./docs/aws-architecture.svg)

# 各AWS Resourceの作成必要性
RDSが動くために必要なResource
- VPC
  - そもそもVPCがないとRDS（仕組みとしてはEC2）を置くことができない。
- DBSubnetGroup
  - RDSを配置するために必要。
  - 必ず2つ以上のsubnetを設定する必要がある
- Private Subnet C, D
  - RDSを配置するSubnetとして必要
  - DBSubnetGroupには2つ登録する必要があるので、2つ作成
- EC2SecurityGroupDefault
  - RDSへのaccess (inbound, outbound)  ruleを管理するために必要
- Cloud9
  - 今回は「RDSでCREATE TABLE」をするために、RDS以外にComputing Resourceを用意する必要があった
  - 操作がIDEでできることから、Cloud9を用意することにした
  - Cloud9の所属するSecurity GroupはCloud9作成時に自動生成されるため、後ほど手動でEC2SecurityGroupDefaultにCloud9で作られたSecurityGroupからのaccessを許可する必要がある


Cloud9が正しく利用できるために必要なResource
- PrivateSubnetC
  - 安全な操作のためにprivate subnetにCloud9を置く場合必要
- EndpointFrom
  - カスタマイズしたsubnetにcloud9を置く場合、各種AWS serviceにcloud9がaccessできるようにするために必要
  - ない場合はCloud9が立ち上がらない

- InternetGateway
  - VPC内に置かれたAWS ResourceからInternetにaccessするために必要
  - 今回はCloud9からRDSにSQL実行するためのprogramをyum installするために必要
- NATGateway
  - private subnetに置かれたResourceからInternetGatewayにaccessするために必要
    - そもそもpublic subnetとの違いは、routing tableに「InternetGateway」へのaccess設定があるか
    - private subnetはInternetGatewayにつながっていないため、「private subnet→Internetのaccessだけ許可する仕組み」としてNATGatewayが必要
- PublicSubnet
  - InternetGatewayにつながっていて、NATGatewayが置かれているSubnet。
  - PrivateSubnetからInternet accessするためには必要

