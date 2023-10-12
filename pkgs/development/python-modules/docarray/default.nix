{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, numpy
, orjson
, pydantic
, rich
, types-requests
, typing-inspect
, pydub
, smart-open
, elastic-transport
, elasticsearch
, av
, jax
, lz4
, pandas
, pillow
, protobuf
, trimesh
, types-pillow
, hnswlib
, jaxlib
, qdrant-client
, redis
, torch
, weaviate-client
, fastapi
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "docarray";
  version = "0.36.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "docarray";
    repo = "docarray";
    rev = "refs/tags/v${version}";
    hash = "sha256-mq8Ldr/PTD6ruAkKHk7AktoaQiUD6EYdYHsT8q5a7wQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    numpy
    orjson
    pydantic
    rich
    types-requests
    typing-inspect
  ];

  passthru.optional-dependencies = {
    audio = [
      pydub
    ];
    aws = [
      smart-open
    ];
    elasticsearch = [
      elastic-transport
      elasticsearch
    ];
    full = [
      av
      jax
      lz4
      pandas
      pillow
      protobuf
      pydub
      trimesh
      types-pillow
    ];
    hnswlib = [
      hnswlib
      protobuf
    ];
    image = [
      pillow
      types-pillow
    ];
    jac = [
      # jina-hubble-sdk
    ];
    jax = [
      jax
      jaxlib
    ];
    mesh = [
      trimesh
    ];
    pandas = [
      pandas
    ];
    proto = [
      lz4
      protobuf
    ];
    qdrant = [
      qdrant-client
    ];
    redis = [
      redis
    ];
    torch = [
      torch
    ];
    video = [
      av
    ];
    weaviate = [
      weaviate-client
    ];
    web = [
      fastapi
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "docarray" ];

  meta = with lib; {
    description = "Represent, send, and store multimodal data · Neural Search · Vector Search · Document Store";
    homepage = "https://github.com/docarray/docarray";
    changelog = "https://github.com/docarray/docarray/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
