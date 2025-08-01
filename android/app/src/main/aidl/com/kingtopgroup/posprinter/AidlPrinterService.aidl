package com.kingtopgroup.posprinter;

import com.kingtopgroup.posprinter.AidlPrinterListener;
import com.kingtopgroup.posprinter.PrintItemObj;
import android.graphics.Bitmap;

interface AidlPrinterService {
    // Thermal printing methods
    int getPrinterState();
    void printText(in List<PrintItemObj> data, AidlPrinterListener listener);
    void printBmp(int align, int width, int height, in Bitmap picture, AidlPrinterListener listener);
    void printBarCode(int width, int height, int barcodetype, in String barcode, AidlPrinterListener listener);
    void setPrinterGray(int gray);
    int setPrintMode(int mode);
    
    // Label printing methods
    void prnInit();
    void paperDetect();
    void feedPaper();
    void prnFontSet(int a, int b);
    void prnSetFontFile(String str);
    void prnBitmap(in Bitmap picture);
    void prnStart();
    void printClose();
}
