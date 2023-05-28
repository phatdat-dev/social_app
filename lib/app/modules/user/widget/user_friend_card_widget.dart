import 'package:flutter/material.dart';

class UserFriendCardWidget extends StatelessWidget {
  final String title;
  final ImageProvider? image;
  final String? subTitle;
  final String? trailingTitle;
  final (String, VoidCallback)? action1;
  final (String, VoidCallback)? action2;

  UserFriendCardWidget({
    super.key,
    required this.title,
    this.subTitle,
    this.trailingTitle,
    this.image,
    this.action1,
    this.action2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: image ?? const AssetImage('assets/images/user_default_icon.png'),
            backgroundColor: Colors.transparent,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (trailingTitle != null) ...[
                    const Spacer(),
                    Text(
                      trailingTitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ]
                ],
              ),
              if (subTitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    subTitle!, //'15 Mutual friends',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              Row(
                children: <Widget>[
                  //Add Friends
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: action1?.$2 ?? () {},
                      child: Text(action1?.$1 ?? 'Add',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface,
                          )),
                    ),
                  ),

                  const SizedBox(width: 5),

                  //Remove
                  Expanded(
                    child: OutlinedButton(
                      onPressed: action2?.$2 ?? () {},
                      child: Text(action2?.$1 ?? 'Remove',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
