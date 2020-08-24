/*
 * JalaliJSCalendar - Jalali Extension for Date Object 
 * Copyright (c) 2008 Ali Farhadi (http://farhadi.ir/)
 * Released under the terms of the GNU General Public License.
 * See the GPL for details (http://www.gnu.org/licenses/gpl.html).
 * 
 * Based on code from http://farsiweb.info
 */

JalaliDate = {
    g_days_in_month: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
    j_days_in_month: [31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29]
};

JalaliDate.jalaliToGregori = function (date) {
    var year = parseInt(date.substr(0, 4));
    var month = parseInt(date.substr(5, 2));
    var day = parseInt(date.substr(8, 2));
    return new Date(JalaliDate.jalaliToGregorian(year,month,day));
};

JalaliDate.jalaliToGregorian = function (j_y, j_m, j_d) {
    j_y = parseInt(j_y);
    j_m = parseInt(j_m);
    j_d = parseInt(j_d);
    var jy = j_y - 979;
    var jm = j_m - 1;
    var jd = j_d - 1;

    var j_day_no = 365 * jy + parseInt(jy / 33) * 8 + parseInt((jy % 33 + 3) / 4);
    for (var i = 0; i < jm; ++i) j_day_no += JalaliDate.j_days_in_month[i];

    j_day_no += jd;

    var g_day_no = j_day_no + 79;

    var gy = 1600 + 400 * parseInt(g_day_no / 146097);
    /* 146097 = 365*400 + 400/4 - 400/100 + 400/400 */
    g_day_no = g_day_no % 146097;

    var leap = true;
    if (g_day_no >= 36525) /* 36525 = 365*100 + 100/4 */
    {
        g_day_no--;
        gy += 100 * parseInt(g_day_no / 36524);
        /* 36524 = 365*100 + 100/4 - 100/100 */
        g_day_no = g_day_no % 36524;

        if (g_day_no >= 365)
            g_day_no++;
        else
            leap = false;
    }

    gy += 4 * parseInt(g_day_no / 1461);
    /* 1461 = 365*4 + 4/4 */
    g_day_no %= 1461;

    if (g_day_no >= 366) {
        leap = false;

        g_day_no--;
        gy += parseInt(g_day_no / 365);
        g_day_no = g_day_no % 365;
    }

    for (var i = 0; g_day_no >= JalaliDate.g_days_in_month[i] + (i == 1 && leap); i++)
        g_day_no -= JalaliDate.g_days_in_month[i] + (i == 1 && leap);
    var gm = i + 1;
    var gd = g_day_no + 1;

    return [gy, gm, gd];
};

JalaliDate.checkDate = function (j_y, j_m, j_d) {
    return !(j_y < 0 || j_y > 32767 || j_m < 1 || j_m > 12 || j_d < 1 || j_d >
        (JalaliDate.j_days_in_month[j_m - 1] + (j_m == 12 && !((j_y - 979) % 33 % 4))));
};

JalaliDate.gregorianToJalali = function (g_y, g_m, g_d) {
    g_y = parseInt(g_y);
    g_m = parseInt(g_m);
    g_d = parseInt(g_d);
    var gy = g_y - 1600;
    var gm = g_m - 1;
    var gd = g_d - 1;

    var g_day_no = 365 * gy + parseInt((gy + 3) / 4) - parseInt((gy + 99) / 100) + parseInt((gy + 399) / 400);

    for (var i = 0; i < gm; ++i)
        g_day_no += JalaliDate.g_days_in_month[i];
    if (gm > 1 && ((gy % 4 == 0 && gy % 100 != 0) || (gy % 400 == 0)))
    /* leap and after Feb */
        ++g_day_no;
    g_day_no += gd;

    var j_day_no = g_day_no - 79;

    var j_np = parseInt(j_day_no / 12053);
    j_day_no %= 12053;

    var jy = 979 + 33 * j_np + 4 * parseInt(j_day_no / 1461);

    j_day_no %= 1461;

    if (j_day_no >= 366) {
        jy += parseInt((j_day_no - 1) / 365);
        j_day_no = (j_day_no - 1) % 365;
    }

    for (var i = 0; i < 11 && j_day_no >= JalaliDate.j_days_in_month[i]; ++i) {
        j_day_no -= JalaliDate.j_days_in_month[i];
    }
    var jm = i + 1;
    var jd = j_day_no + 1;

    jm = jm < 10 ? "0" + jm.toString() : jm.toString();
    jd = jd < 10 ? "0" + jd.toString() : jd.toString();
    return jy + "/" + jm + "/" + jd;
    // return [jy, jm, jd];
};

Date.prototype.setJalaliFullYear = function (y, m, d) {
    var gd = this.getDate();
    var gm = this.getMonth();
    var gy = this.getFullYear();
    var j = JalaliDate.gregorianToJalali(gy, gm + 1, gd);
    if (y < 100) y += 1300;
    j[0] = y;
    if (m != undefined) {
        if (m > 11) {
            j[0] += Math.floor(m / 12);
            m = m % 12;
        }
        j[1] = m + 1;
    }
    if (d != undefined) j[2] = d;
    var g = JalaliDate.jalaliToGregorian(j[0], j[1], j[2]);
    return this.setFullYear(g[0], g[1] - 1, g[2]);
};

Date.prototype.setJalaliMonth = function (m, d) {
    var gd = this.getDate();
    var gm = this.getMonth();
    var gy = this.getFullYear();
    var j = JalaliDate.gregorianToJalali(gy, gm + 1, gd);
    if (m > 11) {
        j[0] += math.floor(m / 12);
        m = m % 12;
    }
    j[1] = m + 1;
    if (d != undefined) j[2] = d;
    var g = JalaliDate.jalaliToGregorian(j[0], j[1], j[2]);
    return this.setFullYear(g[0], g[1] - 1, g[2]);
};

Date.prototype.setJalaliDate = function (d) {
    var gd = this.getDate();
    var gm = this.getMonth();
    var gy = this.getFullYear();
    var j = JalaliDate.gregorianToJalali(gy, gm + 1, gd);
    j[2] = d;
    var g = JalaliDate.jalaliToGregorian(j[0], j[1], j[2]);
    return this.setFullYear(g[0], g[1] - 1, g[2]);
};

Date.prototype.getJalaliFullYear = function () {
    var gd = this.getDate();
    var gm = this.getMonth();
    var gy = this.getFullYear();
    var j = JalaliDate.gregorianToJalali(gy, gm + 1, gd);
    return j[0];
};

Date.prototype.getJalaliMonth = function () {
    var gd = this.getDate();
    var gm = this.getMonth();
    var gy = this.getFullYear();
    var j = JalaliDate.gregorianToJalali(gy, gm + 1, gd);
    return j[1] - 1;
};

Date.prototype.getJalaliDate = function () {
    var gd = this.getDate();
    var gm = this.getMonth();
    var gy = this.getFullYear();
    var j = JalaliDate.gregorianToJalali(gy, gm + 1, gd);
    return j[2];
};

Date.prototype.getJalaliDay = function () {
    var day = this.getDay();
    day = (day + 1) % 7;
    return day;
};


/**
 * Jalali UTC functions
 */

Date.prototype.setJalaliUTCFullYear = function (y, m, d) {
    var gd = this.getUTCDate();
    var gm = this.getUTCMonth();
    var gy = this.getUTCFullYear();
    var j = JalaliDate.gregorianToJalali(gy, gm + 1, gd);
    if (y < 100) y += 1300;
    j[0] = y;
    if (m != undefined) {
        if (m > 11) {
            j[0] += Math.floor(m / 12);
            m = m % 12;
        }
        j[1] = m + 1;
    }
    if (d != undefined) j[2] = d;
    var g = JalaliDate.jalaliToGregorian(j[0], j[1], j[2]);
    return this.setUTCFullYear(g[0], g[1] - 1, g[2]);
};

Date.prototype.setJalaliUTCMonth = function (m, d) {
    var gd = this.getUTCDate();
    var gm = this.getUTCMonth();
    var gy = this.getUTCFullYear();
    var j = JalaliDate.gregorianToJalali(gy, gm + 1, gd);
    if (m > 11) {
        j[0] += math.floor(m / 12);
        m = m % 12;
    }
    j[1] = m + 1;
    if (d != undefined) j[2] = d;
    var g = JalaliDate.jalaliToGregorian(j[0], j[1], j[2]);
    return this.setUTCFullYear(g[0], g[1] - 1, g[2]);
};

Date.prototype.setJalaliUTCDate = function (d) {
    var gd = this.getUTCDate();
    var gm = this.getUTCMonth();
    var gy = this.getUTCFullYear();
    var j = JalaliDate.gregorianToJalali(gy, gm + 1, gd);
    j[2] = d;
    var g = JalaliDate.jalaliToGregorian(j[0], j[1], j[2]);
    return this.setUTCFullYear(g[0], g[1] - 1, g[2]);
};

Date.prototype.getJalaliUTCFullYear = function () {
    var gd = this.getUTCDate();
    var gm = this.getUTCMonth();
    var gy = this.getUTCFullYear();
    var j = JalaliDate.gregorianToJalali(gy, gm + 1, gd);
    return j[0];
};

Date.prototype.getJalaliUTCMonth = function () {
    var gd = this.getUTCDate();
    var gm = this.getUTCMonth();
    var gy = this.getUTCFullYear();
    var j = JalaliDate.gregorianToJalali(gy, gm + 1, gd);
    return j[1] - 1;
};

Date.prototype.getJalaliUTCDate = function () {
    var gd = this.getUTCDate();
    var gm = this.getUTCMonth();
    var gy = this.getUTCFullYear();
    var j = JalaliDate.gregorianToJalali(gy, gm + 1, gd);
    return j[2];
};

Date.prototype.getJalaliUTCDay = function () {
    var day = this.getUTCDay();
    day = (day + 1) % 7;
    return day;
};

function checkBirthDate(date) {
    var checkDateFlag = checkDate(date);

    if (checkDateFlag) {
        var day = parseInt(date.substr(8, 2));
        var month = parseInt(date.substr(5, 2));
        var year = parseInt(date.substr(0, 4));

        var jeoDate = new Date(JalaliDate.jalaliToGregorian(year, month, day));
        var todayDate = new Date();
        if (Date.compareDates(jeoDate, todayDate) === -1)
            return false;
        return true;
    } else
        return checkDateFlag;
}


function checkDate(date) {
    var khMonth = [0, 31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29];
    var dateIndex = [0, 1, 2, 3, 5, 6, 8, 9];
    if (date.length !== 10)
        return false;
    var month = parseInt(date.substr(5, 2));
    var day = parseInt(date.substr(8, 2));
    var year = parseInt(date.substr(0, 4));

    if(year < 1200)
        return false;
    if (date[4] !== "/" || date[7] !== "/")
        return false;
    if (month > 12)
        return false;
    if (day > khMonth[month] || day < 1)
        return false;
    for (var i = 0; i < dateIndex.length; i++) {
        if (date[dateIndex[i]] === "/") {
            return false;
        }
    }
    return true;
}

JalaliDate.addMonths = function(date, months) {
    var d = date.getDate();
    date.setMonth(date.getMonth() + +months);
    if (date.getDate() != d) {
        date.setDate(0);
    }
    return date;
}

JalaliDate.JalaliTodayDate = function(){
    week = new Array("يكشنبه", "دوشنبه", "سه شنبه", "چهارشنبه", "پنج شنبه", "جمعه", "شنبه")
    months = new Array("فروردين", "ارديبهشت", "خرداد", "تير", "مرداد", "شهريور", "مهر", "آبان", "آذر", "دي", "بهمن", "اسفند");
    today = new Date();
    d = today.getDay();
    day = today.getDate();
    month = today.getMonth() + 1;
    year = today.getYear();
    year = (window.navigator.userAgent.indexOf('MSIE') > 0) ? year : 1900 + year;
    if (year == 0) {
        year = 2000;
    }
    if (year < 100) {
        year += 1900;
    }
    y = 1;
    for (i = 0; i < 3000; i += 4) {
        if (year == i) {
            y = 2;
        }
    }
    for (i = 1; i < 3000; i += 4) {
        if (year == i) {
            y = 3;
        }
    }
    if (y == 1) {
        year -= ((month < 3) || ((month == 3) && (day < 21))) ? 622 : 621;
        switch (month) {
            case 1:
                (day < 21) ? (month = 10, day += 10) : (month = 11, day -= 20);
                break;
            case 2:
                (day < 20) ? (month = 11, day += 11) : (month = 12, day -= 19);
                break;
            case 3:
                (day < 21) ? (month = 12, day += 9) : (month = 1, day -= 20);
                break;
            case 4:
                (day < 21) ? (month = 1, day += 11) : (month = 2, day -= 20);
                break;
            case 5:
            case 6:
                (day < 22) ? (month -= 3, day += 10) : (month -= 2, day -= 21);
                break;
            case 7:
            case 8:
            case 9:
                (day < 23) ? (month -= 3, day += 9) : (month -= 2, day -= 22);
                break;
            case 10:
                (day < 23) ? (month = 7, day += 8) : (month = 8, day -= 22);
                break;
            case 11:
            case 12:
                (day < 22) ? (month -= 3, day += 9) : (month -= 2, day -= 21);
                break;
            default:
                break;
        }
    }
    if (y == 2) {
        year -= ((month < 3) || ((month == 3) && (day < 20))) ? 622 : 621;
        switch (month) {
            case 1:
                (day < 21) ? (month = 10, day += 10) : (month = 11, day -= 20);
                break;
            case 2:
                (day < 20) ? (month = 11, day += 11) : (month = 12, day -= 19);
                break;
            case 3:
                (day < 20) ? (month = 12, day += 10) : (month = 1, day -= 19);
                break;
            case 4:
                (day < 20) ? (month = 1, day += 12) : (month = 2, day -= 19);
                break;
            case 5:
                (day < 21) ? (month = 2, day += 11) : (month = 3, day -= 20);
                break;
            case 6:
                (day < 21) ? (month = 3, day += 11) : (month = 4, day -= 20);
                break;
            case 7:
                (day < 22) ? (month = 4, day += 10) : (month = 5, day -= 21);
                break;
            case 8:
                (day < 22) ? (month = 5, day += 10) : (month = 6, day -= 21);
                break;
            case 9:
                (day < 22) ? (month = 6, day += 10) : (month = 7, day -= 21);
                break;
            case 10:
                (day < 22) ? (month = 7, day += 9) : (month = 8, day -= 21);
                break;
            case 11:
                (day < 21) ? (month = 8, day += 10) : (month = 9, day -= 20);
                break;
            case 12:
                (day < 21) ? (month = 9, day += 10) : (month = 10, day -= 20);
                break;
            default:
                break;
        }
    }
    if (y == 3) {
        year -= ((month < 3) || ((month == 3) && (day < 21))) ? 622 : 621;
        switch (month) {
            case 1:
                (day < 20) ? (month = 10, day += 11) : (month = 11, day -= 19);
                break;
            case 2:
                (day < 19) ? (month = 11, day += 12) : (month = 12, day -= 18);
                break;
            case 3:
                (day < 21) ? (month = 12, day += 10) : (month = 1, day -= 20);
                break;
            case 4:
                (day < 21) ? (month = 1, day += 11) : (month = 2, day -= 20);
                break;
            case 5:
            case 6:
                (day < 22) ? (month -= 3, day += 10) : (month -= 2, day -= 21);
                break;
            case 7:
            case 8:
            case 9:
                (day < 23) ? (month -= 3, day += 9) : (month -= 2, day -= 22);
                break;
            case 10:
                (day < 23) ? (month = 7, day += 8) : (month = 8, day -= 22);
                break;
            case 11:
            case 12:
                (day < 22) ? (month -= 3, day += 9) : (month -= 2, day -= 21);
                break;
            default:
                break;
        }
    }
    if(month<10 && day<10)
        return year + "/0" + month + "/0" + day;
    else if(month>=10 && day<10)
        return year + "/" + month + "/0" + day;
    else if(month<10 && day>=10)
        return year + "/0" + month + "/" + day;
    else
        return year + "/" + month + "/" + day;

}
