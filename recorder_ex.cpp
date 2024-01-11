#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include <sys/stat.h>
#include <signal.h>

#include "json/json.h"
#include "datools.h"
#include "SB_System.h"
#include "SB_Network.h"
#include "ConfigTextFile.h"
#include "multipart_parser.h"
#include "http_multipart.h"
#include "pai_r_data.h"
#include "pai_r_updatelog.h"

#include "httpd_pai_r.h"
#include "httpd_r3.h"
#include "recorder_ex.h"


extern bool g_httpdExitNow;
const char *g_app_name = "PAI_R_HTTPD";
static bool g_httpd_start = false;

int pai_r_httpd_start(void)
{
	if(g_httpd_start == false || g_httpdExitNow) {
		g_httpdExitNow = false;
		g_httpd_start = true;
		printf( "%s : START(ver : %s [%s %s])\r\n", g_app_name, HTTPD_R3_VERSION, __DATE__, __TIME__);

		httpd_start(80);
	}	
	return 1;
}

int pai_r_httpd_end(void)
{
	if(g_httpd_start){
		httpd_end();
		printf("%s : END\n\n", g_app_name);
	}
	g_httpd_start = false;
	return 1;
}