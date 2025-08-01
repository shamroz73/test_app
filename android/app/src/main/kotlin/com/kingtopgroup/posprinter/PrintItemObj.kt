package com.kingtopgroup.posprinter

import android.os.Parcel
import android.os.Parcelable

data class PrintItemObj(
    val text: String = "",
    val fontSize: Int = 24,
    val align: Int = 0, // 0=left, 1=center, 2=right
    val isBold: Boolean = false,
    val isUnderline: Boolean = false
) : Parcelable {
    
    constructor(parcel: Parcel) : this(
        parcel.readString() ?: "",
        parcel.readInt(),
        parcel.readInt(),
        parcel.readByte() != 0.toByte(),
        parcel.readByte() != 0.toByte()
    )

    override fun writeToParcel(parcel: Parcel, flags: Int) {
        parcel.writeString(text)
        parcel.writeInt(fontSize)
        parcel.writeInt(align)
        parcel.writeByte(if (isBold) 1 else 0)
        parcel.writeByte(if (isUnderline) 1 else 0)
    }

    override fun describeContents(): Int {
        return 0
    }

    companion object CREATOR : Parcelable.Creator<PrintItemObj> {
        override fun createFromParcel(parcel: Parcel): PrintItemObj {
            return PrintItemObj(parcel)
        }

        override fun newArray(size: Int): Array<PrintItemObj?> {
            return arrayOfNulls(size)
        }
    }
}
