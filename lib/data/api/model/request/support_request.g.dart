// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportRequest _$SupportRequestFromJson(Map<String, dynamic> json) =>
    SupportRequest(
      type: json['type'] as String,
      subject: json['subject'] as String?,
      description: json['description'] as String?,
      email: json['email'] as String?,
      createdAt: json['createdAt'] as int,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$SupportRequestToJson(SupportRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'subject': instance.subject,
      'description': instance.description,
      'email': instance.email,
      'createdAt': instance.createdAt,
      'userId': instance.userId,
    };
