#encoding:utf-8
class ScreenshotStatus < Enum
  additional_attr :color
  
  define :waiting,   1, "キャプチャ待ち",   "green"
  define :captured, 2, "キャプチャ済",     "blue"
  define :error,    9, "キャプチャエラー", "red"
end