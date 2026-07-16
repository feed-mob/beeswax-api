PROTOC ?= protoc

.PHONY: generate-go test-go

# The upstream schemas require protoc 3.12.3; newer releases reject legacy
# enum names in openrtb_common.proto.
generate-go:
	@set -eu; \
	files="$$(find beeswax -name '*.proto' -print | sort)"; \
	opts=""; \
	for file in $$files; do \
		dir=$${file%/*}; \
		opts="$$opts --go_opt=M$$file=github.com/feed-mob/beeswax-api/$$dir"; \
	done; \
	PATH="$$(go env GOPATH)/bin:$$PATH" $(PROTOC) --go_out=. --go_opt=module=github.com/feed-mob/beeswax-api $$opts $$files
	go mod tidy

test-go:
	go test ./...
