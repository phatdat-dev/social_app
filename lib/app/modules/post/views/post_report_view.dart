import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/modules/post/controllers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostReportView extends StatefulWidget {
  const PostReportView({super.key, required this.postId});
  final int postId;

  @override
  State<PostReportView> createState() => _PostReportViewState();
}

class _PostReportViewState extends State<PostReportView> {
  final reports = [
    {
      'id': 0,
      'content': 'Bạo lực',
      'description': ['Đe dọa bạo lực', 'Người hoặc tổ chức nguy hiểm', 'Hình ảnh bạo lực phản cảm cực đoan', 'Một loại bạo lực khác']
    },
    {
      'id': 1,
      'content': 'Thư rác',
      'description': [
        'Mua, bán hoặc tặng tài khoản, vai trò hoặc quyền',
        'Khuyến khích mọi người tương tác với nội dung giả vờ sai sự thật',
        'Hướng mọi người ra khỏi CKCSocial thông qua việc sử dụng liên kết gây hiểu lầm',
      ]
    },
    {'id': 2, 'content': 'Quấy rối', 'description': []},
    {
      'id': 3,
      'content': 'Bán hàng trái phép',
      'description': ['Vũ khí', 'Chất cấm', 'Buôn người', 'Một cái gì đó khác']
    },
    {
      'id': 4,
      'content': 'Lời nói căm thù',
      'description': [
        'Chủng tộc, sắc tộc',
        'Nguồn gốc quốc gia',
        'Liên kết tôn giáo',
        'Xu hướng tình dục',
        'Giới tính hoặc bán dạng giới',
        'Khuyết tật hoặc bệnh tật',
        'Một cái gì đó khác'
      ]
    },
    {'id': 5, 'content': 'Khủng bố', 'description': []},
    {
      'id': 6,
      'content': 'Thông tin sai lệch',
      'description': ['Chính trị', 'Vấn đề xã hội', 'Sức khỏe', 'Một cái gì đó khác']
    },
    {
      'id': 7,
      'content': 'Tự tử hoặc gây thương tích',
      'description': ['Yêu cầu chúng tôi xem về vấn đề này.']
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.ReportPost.tr),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Text('Vui lòng chọn một vấn đề', style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ...reports.map(
              (e) => ExpansionTile(
                title: Text(e['content'].toString()),
                children: (e['description'] as List)
                    .map(
                      (e2) => ListTile(
                        title: Text('* $e2'),
                        onTap: () async {
                          final result = await HelperWidget.showGenericDialog(
                            context: context,
                            title: LocaleKeys.Confirm.tr,
                            content: 'Xác nhận báo cáo ?',
                            optionsBuilder: () => {LocaleKeys.Cancel.tr: false, 'OK': true},
                          );
                          if (result == true) {
                            Get.find<PostController>().call_createReportPost(e['id'] as int, widget.postId, "${e['content']}, $e2").then((value) {
                              Get.back();
                              HelperWidget.showSnackBar(message: 'Report thành công');
                            });
                          }
                        },
                        trailing: const Icon(Icons.report_outlined, color: Colors.red),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
