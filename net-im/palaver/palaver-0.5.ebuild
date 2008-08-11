# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python distutils
DESCRIPTION="Multi-user chat component for jabber implemented in python"
HOMEPAGE="http://onlinegamegroup.com/projects/palaver/"
SRC_URI="http://onlinegamegroup.com/releases/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="net-im/jabber-base"
RDEPEND=">=dev-python/twisted-2.4.0
>=dev-python/twisted-words-0.5
${DEPEND}"

src_unpack() {
	unpack ${A} && cd "${S}" || die "unpack failed"
}

src_compile() {
	# nothing to be done here?
	distutils_src_compile
}

src_install() {
	distutils_src_install

	insinto /etc/jabber
	newins example-config.xml ${PN}.xml
	fperms 600 /etc/jabber/${PN}.xml
	fowners jabber:jabber /etc/jabber/${PN}.xml
	dosed \
		"s:<spool>[^\<]*</spool>:<spool>/var/spool/jabber</spool>:" \
		/etc/jabber/${PN}.xml

#	dosed \
#		"s:<pid>[^\<]*</pid>:<pid>/var/run/jabber/${PN}.pid</pid>:" \
#		/etc/jabber/${PN}.xml

	newinitd "${FILESDIR}/${P}-initd" ${PN}
#	dosed "s:INSPATH:${inspath}:" /etc/init.d/${PN}

}

pkg_postinst() {
	einfo "A sample config file has been installed into /etc/jabber/${PN}.xml."
	einfo "Please adjust the settings as needed."
	einfo "After that, you MUST create a TAP-file for twisted in order to start Palaver, like this:"
	einfo "# cd /etc/jabber"
	einfo "# mktap palaver -c palaver.xml"
}
