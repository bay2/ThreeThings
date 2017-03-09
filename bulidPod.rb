p "make up cartfile"
cartfile = File.open("Cartfile", 'w')
cartfile.write('github "ReXSwift/ReX" "1.0.0-rc.2"' + "\n")
cartfile.write('github "ReactiveX/RxSwift" ~> 3.0' + "\n")
cartfile.write('github "jdg/MBProgressHUD" ~> 1.0' + "\n")
cartfile.write('github "mac-cain13/R.swift.Library" ~> 3.0.2' + "\n")
cartfile.close()

# 生成一个叫 Cartfile 的文件，让里面写入后面的字符串
p "carthage update"
`carthage update --verbose --platform iOS --no-use-binaries --color auto`
p "carthage update finish"

`rm -rf `
