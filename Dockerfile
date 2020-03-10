FROM debian

# Install dependencies
RUN apt-get -y update \
	&& apt-get -y upgrade \
	 && apt-get -y install \
		bash \
		curl \
		tar \
		xz-utils \
		git \
		libstdc++6 \
		lib32stdc++6 \
		jq


# Install latest version of flutter stable with included dart compiler
RUN cd /opt \
	&& FLUTTER_VERSIONS_URL='https://storage.googleapis.com/flutter_infra/releases/releases_linux.json' \
	&& FLUTTER_URL=$(curl $FLUTTER_VERSIONS_URL | jq -r '.current_release.stable as $version | .base_url + "/" + (.releases[] | select(.hash == $version) | select(.channel == "stable") ).archive') \
	&& curl $FLUTTER_URL | tar xJf -

# Create symlink of flutter
RUN set -eux \
	&& ln -s /opt/flutter/bin/flutter /usr/local/bin/flutter \
	&& flutter upgrade \
	&& flutter precache \
	&& flutter doctor
