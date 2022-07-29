# Copyright 2022 Marius Kießling
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.18.4 as build
# We will inject the upstream commit hash to check out the specific commit
# referenced by a version.
ARG TARGETOS TARGETARCH UPSTREAM_COMMIT
WORKDIR /build
RUN git clone https://github.com/GoogleCloudPlatform/govanityurls.git .
RUN git checkout $UPSTREAM_COMMIT
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o govanityurls -ldflags="-extldflags=-static"

FROM gcr.io/distroless/static@sha256:21d3f84a4f37c36199fd07ad5544dcafecc17776e3f3628baf9a57c8c0181b3f
COPY --from=build /build/govanityurls /
CMD ["/govanityurls", "vanity.yaml"]
