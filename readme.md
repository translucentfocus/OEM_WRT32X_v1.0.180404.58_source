OEM WRT32X_v1.0.180404.58 firmware source code pulled from https://www.linksys.com/us/support-article?articleNum=114663

The firmware source code is the same for either the WRT32X or WRT32XB.  The firmware checks the router's hardware version to activate Xbox Detection for the WRT32XB

You can see that in action here:  https://github.com/translucentfocus/OEM_WRT32X_v1.0.180404.58_source/blob/8bcced1af782ba56aa1f431eac3537f0df5e34ea/core-master/linksys/feed/sartura/sambuca-web-device/uci-defaults/99_xbox_sku
