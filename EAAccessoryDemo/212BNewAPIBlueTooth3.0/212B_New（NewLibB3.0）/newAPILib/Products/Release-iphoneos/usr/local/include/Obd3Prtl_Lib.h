/*
 ******************************************************************************
 *
 *  OBDII V3.25 Protocol Analyze Lib
 *  Version: V1.0.0
 *  DateTime: 2014-12-15
 *  By: Li Guoquan (gqli@sinocastel.com)
 *  Copy Right(C) Sinocastel Shenzhen Co., Ltd.
 *
 ******************************************************************************
*/


#ifndef _cOBD3XPROTL_LIB_h
#define _cOBD3XPROTL_LIB_h


#ifdef __cplusplus
extern "C"
{
#endif

//---------------------------------------------------------------------------
int    init(char *deviceId, char *dataNum);
char * setCtrl(int inCtrlIndex);
char * setMonitor(void);
char * setParameter(char *tlvTagList, char *valueList);
char * getParameter(char *tlvTag);
char * getIOData(char *inData);

//---------------------------------------------------------------------------

#ifdef __cplusplus
}
#endif

#endif


