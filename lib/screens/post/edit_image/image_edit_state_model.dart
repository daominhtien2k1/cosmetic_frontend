import './stacked_widget_model.dart';
import './color_filter_model.dart';
import './border_model.dart';

class ImageEditStateModel{
  String? type;
  double? number;
  String? data;
  StackedWidgetModel? widget;
  ColorFilterModel? filter;
  BorderModel? border;
  ImageEditStateModel({this.widget,this.data,this.type,this.filter,this.number,this.border});
}