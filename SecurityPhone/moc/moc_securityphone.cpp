/****************************************************************************
** Meta object code from reading C++ file 'securityphone.h'
**
** Created: Sun Jan 27 10:40:13 2013
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../securityphone.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'securityphone.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_SecurityPhone[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
      12,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      21,   15,   14,   14, 0x0a,

 // methods: signature, parameters, type, tag, flags
      59,   52,   14,   14, 0x02,
      88,   14,   83,   14, 0x02,
     106,   14,   14,   14, 0x02,
     128,   14,   14,   14, 0x02,
     149,   52,   14,   14, 0x02,
     167,   52,   14,   14, 0x02,
     189,   52,   14,   14, 0x02,
     209,   52,   14,   14, 0x02,
     228,   52,   14,   14, 0x02,
     250,  245,   14,   14, 0x02,
     277,   14,   14,   14, 0x02,

       0        // eod
};

static const char qt_meta_stringdata_SecurityPhone[] = {
    "SecurityPhone\0\0state\0"
    "onChangeOrientationChange(int)\0enable\0"
    "orientationEnable(bool)\0bool\0"
    "isPassRecording()\0startPasswordRecord()\0"
    "stopPasswordRecord()\0switchSound(bool)\0"
    "switchVibration(bool)\0switchStandBy(bool)\0"
    "switchAnonym(bool)\0switchMail(bool)\0"
    "mail\0switchMailAddress(QString)\0"
    "startService()\0"
};

const QMetaObject SecurityPhone::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_SecurityPhone,
      qt_meta_data_SecurityPhone, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &SecurityPhone::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *SecurityPhone::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *SecurityPhone::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_SecurityPhone))
        return static_cast<void*>(const_cast< SecurityPhone*>(this));
    return QObject::qt_metacast(_clname);
}

int SecurityPhone::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: onChangeOrientationChange((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 1: orientationEnable((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 2: { bool _r = isPassRecording();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 3: startPasswordRecord(); break;
        case 4: stopPasswordRecord(); break;
        case 5: switchSound((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 6: switchVibration((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 7: switchStandBy((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 8: switchAnonym((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 9: switchMail((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 10: switchMailAddress((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 11: startService(); break;
        default: ;
        }
        _id -= 12;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
