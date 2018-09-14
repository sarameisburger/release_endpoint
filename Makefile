
image:
	docker build --rm -t ruby/release_endpoint .
run:
	docker run -d --restart=on-failure:10 --name release_endpoint -p 8334:8334 -v $(shell pwd):/app ruby/release_endpoint

run_dev:
	docker run -d --restart=on-failure:10 --name release_endpoint -p 8334:8334 -v $(shell pwd):/app ruby/release_endpoint shotgun --host 0.0.0.0 --port 8334 /app/app.rb

clean:
	docker stop release_endpoint || true
	docker rm release_endpoint || true
