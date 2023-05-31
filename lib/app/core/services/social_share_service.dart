import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

//from https://www.youtube.com/watch?v=bWehAFTFc9o
enum SocialShareType {
  facebook,
  twitter,
  instagram,
  whatsapp,
  messenger,
  sms,
  email,
  copyLink,
  linkedin,
  telegram,
  tumblr,
  reddit;

  //https://codewithandrea.com/articles/whats-new-dart-3-introduction/
  String get icon => switch (this) {
        facebook => 'https://i.pinimg.com/564x/b2/ef/68/b2ef689d1f387dfc949d0f63c3865441.jpg',
        twitter => 'https://i.pinimg.com/564x/ec/41/47/ec41475eafca0883460602acf1b59e82.jpg',
        instagram => 'https://i.pinimg.com/564x/c8/95/2d/c8952d6e421a83d298a219edee783167.jpg',
        whatsapp => 'https://i.pinimg.com/564x/9d/8e/ee/9d8eeeb48038d5067cca3fe71521261f.jpg',
        messenger => 'https://i.pinimg.com/236x/b7/7f/43/b77f43e708a4cd664a7405c21f8302ca.jpg',
        sms => 'https://i.pinimg.com/236x/65/42/59/65425944829bad0ee8699cb9429d0c62.jpg',
        email => 'https://i.pinimg.com/236x/ca/27/f6/ca27f615c790f1af43f2dd564599bf6a.jpg',
        copyLink => 'https://i.pinimg.com/236x/7b/07/79/7b077939dcda060902df44d3700b6d56.jpg',
        linkedin => 'https://i.pinimg.com/236x/49/32/80/49328097f84b5b6d80ffe0c104e4f429.jpg',
        telegram => 'https://i.pinimg.com/236x/4e/15/3a/4e153ad049207fc2c7146e0d161ea74c.jpg',
        tumblr => 'https://i.pinimg.com/236x/61/34/c4/6134c46627dbcc27469f200f87d0f5b7.jpg',
        reddit => 'https://i.pinimg.com/236x/99/d1/da/99d1daa6a4634f84c5ea3afca79ffb3a.jpg',
      };

  String getUrl({
    required String urlShare,
    String? text,
    String? subject,
  }) =>
      switch (this) {
        facebook => 'https://www.facebook.com/sharer/sharer.php?u=$urlShare&t=$text',
        twitter => 'https://twitter.com/intent/tweet?url=$urlShare&text=$text',
        instagram => 'https://www.instagram.com/?url=$urlShare',
        whatsapp => 'https://api.whatsapp.com/send?text=$text $urlShare',
        messenger => 'https://www.facebook.com/dialog/send?app_id=184683071273&link=$urlShare&redirect_uri=$urlShare',
        sms => 'sms:?body=$text $urlShare',
        email => 'https://mail.google.com/mail/?view=cm&fs=1&su=$subject&body=$text $urlShare',
        copyLink => urlShare,
        linkedin => 'https://www.linkedin.com/shareArticle?mini=true&url=$urlShare&title=$subject&summary=$text&source=$urlShare',
        telegram => 'https://telegram.me/share/url?url=$urlShare&text=$text',
        tumblr => 'https://www.tumblr.com/widgets/share/tool?canonicalUrl=$urlShare&title=$subject&caption=$text',
        reddit => 'https://www.reddit.com/submit?url=$urlShare&title=$subject',
      };
}

class SocialShareService extends GetxService {
  Future<SocialShareService> init() async {
    return this;
  }

  Future<void> onShare({
    required SocialShareType type,
    required String urlShare,
    String? text,
    String? subject,
  }) async {
    urlShare = Uri.encodeComponent(urlShare);

    final Uri url = Uri.parse(type.getUrl(urlShare: urlShare, text: text, subject: subject));
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
    }
  }
}
