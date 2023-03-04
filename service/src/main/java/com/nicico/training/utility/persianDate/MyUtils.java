package com.nicico.training.utility.persianDate;

import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.iservice.IParameterValueService;
import com.nicico.training.model.Tclass;
import dto.exam.ClassType;
import dto.exam.CourseStatus;
import dto.exam.EQuestionType;
import net.jcip.annotations.ThreadSafe;
import org.apache.commons.lang3.StringUtils;
import response.tclass.dto.CourseProgramDTO;
import response.tclass.dto.WeekDays;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static dto.exam.EQuestionType.*;

/**
 * This class provides static helper methods, in order to remove boilerplate code.
 * It is not possible to get an instance of this class.
 * <p>
 * This class is stateless and thread-safe.
 *
 * @author Mahmoud Fathi
 */
@ThreadSafe
public class MyUtils {

    // Ensure non-instantiability
    private MyUtils() {
        throw new UnsupportedOperationException();
    }

    /**
     * Returns true if and only if {@code val} is greater than or equal to {@code lowerLimit}
     * and is less than or equal to {@code upperLimit}.
     *
     * @param val        the value to be checked, an integer
     * @param lowerLimit lower boundary to be checked, an integer
     * @param upperLimit upper boundary to be checked, an integer
     * @return true if and only if {@code val} is between {@code lowerLimit} and
     * {@code upperLimit}
     */
    static boolean isBetween(int val, int lowerLimit, int upperLimit) {
        return val >= lowerLimit && val <= upperLimit;
    }

    /**
     * Returns true if and only if {@code val} is greater than or equal to {@code lowerLimit}
     * and is less than or equal to {@code upperLimit}.
     *
     * @param val        the value to be checked, a long
     * @param lowerLimit lower boundary to be checked, a long
     * @param upperLimit upper boundary to be checked, a long
     * @return true if and only if {@code val} is between {@code lowerLimit} and
     * {@code upperLimit}
     */
    static boolean isBetween(long val, long lowerLimit, long upperLimit) {
        return val >= lowerLimit && val <= upperLimit;
    }

    /**
     * Checks whether an integer is in a range or not. If {@code val} is less than
     * {@code lowerLimit} or greater than {@code upperLimit}, an IllegalArgumentException
     * will be thrown with a suitable message.
     *
     * @param val        value to check
     * @param lowerLimit lower limit of range
     * @param upperLimit upper limit of range
     * @param valName    the name of {@code val} that is printed in the exception message
     * @return {@code val}, if it is in the range
     */
    static int intRequireRange(int val, int lowerLimit, int upperLimit, String valName) {
        if (!isBetween(val, lowerLimit, upperLimit)) {
            throw new IllegalArgumentException(valName + " " + val +
                    " is out of valid range [" + lowerLimit + ", " + upperLimit + "]");
        }
        return val;
    }

    /**
     * Checks whether an integer is greater than zero or not. If {@code val} is less than
     * or equal to zero, an IllegalArgumentException will be thrown with a suitable message.
     *
     * @param val     integer value to check
     * @param valName name of {@code val} that is printed in the exception message
     * @return {@code val}, if it is positive
     */
    static int intRequirePositive(int val, String valName) {
        if (val <= 0) {
            throw new IllegalArgumentException(valName + " is not positive: " + val);
        }
        return val;
    }

    /**
     * Checks whether a long is greater than zero or not. If {@code val} is less than
     * or equal to zero, an IllegalArgumentException will be thrown with a suitable message.
     *
     * @param val     long value to check
     * @param valName name of {@code val} that is printed in the exception message
     * @return {@code val}, if it is positive
     */
    static long longRequirePositive(long val, String valName) {
        if (val <= 0) {
            throw new IllegalArgumentException(valName + " is not positive: " + val);
        }
        return val;
    }

    /**
     * Checks whether a long is in a range or not. If {@code val} is less than
     * {@code lowerLimit} or greater than {@code upperLimit}, an IllegalArgumentException
     * will be thrown with a suitable message.
     *
     * @param val        value to check
     * @param lowerLimit lower limit of range
     * @param upperLimit upper limit of range
     * @param valName    the name of {@code val} that is printed in the exception message
     * @return {@code val}, if it is in the range
     */
    static long longRequireRange(long val, long lowerLimit, long upperLimit, String valName) {
        if (val < lowerLimit || val > upperLimit){
                throw new IllegalArgumentException(valName + " " + val +
                        " is out of valid range [" + lowerLimit + ", " + upperLimit + "]");
            }
        return val;
    }
    public static String convertToEnglishDigits(String value)
    {
        return value.replace("١", "1").replace("٢", "2").replace("٣", "3").replace("٤", "4").replace("٥", "5")
                .replace("٦", "6").replace("7", "٧").replace("٨", "8").replace("٩", "9").replace("٠", "0")
                .replace("۱", "1").replace("۲", "2").replace("۳", "3").replace("۴", "4").replace("۵", "5")
                .replace("۶", "6").replace("۷", "7").replace("۸", "8").replace("۹", "9").replace("۰", "0");
    }

    public static List<CourseProgramDTO> getPrograms2(Tclass tclass) {
        List<CourseProgramDTO> programs = new ArrayList<>();
        if (null != (tclass.getSaturday()) && tclass.getSaturday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(1));
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(1));
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(1));
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(1));
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(1));
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getSunday()) && tclass.getSunday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(2));
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(2));
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(2));
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(2));
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(2));
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getMonday()) && tclass.getMonday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(3));
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(3));
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(3));
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(3));
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(3));
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getTuesday()) && tclass.getTuesday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(4));
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(4));
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(4));
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(4));
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(4));
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getWednesday()) && tclass.getWednesday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(5));
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(5));
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(5));
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(5));
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(5));
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getThursday()) && tclass.getThursday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(6));
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(6));
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(6));
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(6));
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(6));
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getFriday()) && tclass.getFriday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(7));
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(7));
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(7));
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(7));
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                CourseProgramDTO program = new CourseProgramDTO();
                program.setDay(getWeekDays(7));
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }

        return programs;
    }


    public static WeekDays getWeekDays(int id) {
        for (WeekDays entry : WeekDays.values()) {
            if (entry.getKey()==id) {
                return entry;
            }
        }
        return null;
    }



    public static ClassType getClassType(int id) {
        for (ClassType entry : ClassType.values()) {
            if (entry.getKey()==id) {
                return entry;
            }
        }
        return null;
    }

    public static CourseStatus getCourseStatus(int id) {
        for (CourseStatus entry : CourseStatus.values()) {
            if (entry.getKey()==id) {
                return entry;
            }
        }
        return null;
    }

    public static boolean checkMobileFormat(String mobileNumber) {
        if (mobileNumber == null || mobileNumber.equals("")) {
            return false;
        } else {
            mobileNumber = StringUtils.leftPad(mobileNumber, 11, "0");
            String regexStr = "^09\\d{9}";
            Pattern pattern = Pattern.compile(regexStr);
            Matcher matcher = pattern.matcher(mobileNumber);
            return matcher.find();
        }
    }

    public static boolean checkEmailFormat(String email) {
        if (email == null || email.equals("")) {
            return false;
        } else {
            String regexStr = "(?i)[-a-z0-9+_][-a-z0-9+_.]*@[-a-z0-9][-a-z0-9.]*\\.[a-z]{2,6}";
            Pattern pattern = Pattern.compile(regexStr);
            Matcher matcher = pattern.matcher(email);
            return matcher.find();
        }
    }
    public static boolean validateNationalCode(String melliCode) {

        String[] identicalDigits = {"0000000000", "1111111111", "2222222222", "3333333333", "4444444444", "5555555555", "6666666666", "7777777777", "8888888888", "9999999999"};

        if (melliCode.trim().isEmpty()) {
            return false; // National Code is empty
        } else if (melliCode.length() != 10) {
            return false; // National Code is less or more than 10 digits
        } else if (Arrays.asList(identicalDigits).contains(melliCode)) {
            return false; // Fake National Code
        } else {
            int sum = 0;

            for (int i = 0; i < 9; i++) {
                sum += Character.getNumericValue(melliCode.charAt(i)) * (10 - i);
            }

            int lastDigit;
            int divideRemaining = sum % 11;

            if (divideRemaining < 2) {
                lastDigit = divideRemaining;
            } else {
                lastDigit = 11 - (divideRemaining);
            }

            if (Character.getNumericValue(melliCode.charAt(9)) == lastDigit) {
                return true;
            } else {
                return false; // Invalid MelliCode
            }
        }
    }

    public static <T> boolean areAllUnique(List<T> list){
        Set<T> set = new HashSet<>();

        for (T t: list){
            if (!set.add(t))
                return false;
        }

        return true;
    }

    public static EQuestionType convertQuestionType(Long questionTypeId, IParameterValueService parameterValueService) {
        ParameterValueDTO.TupleInfo info = parameterValueService.getInfo(questionTypeId);
        return switch (info.getTitle()) {
            case "چند گزینه ای" -> MULTI_CHOICES;
            case "تشریحی" -> DESCRIPTIVE;
            case "سوالات گروهی" -> GROUPQUESTION;
            default -> null;
        };
    }

    public static boolean isEvaluationExpired(String endDateStr, String type,int deadLineDaysValue) {
        Date endDateEpoch = PersianDate.getEpochDate(endDateStr, "23:59");
        long endDateTimestamp = endDateEpoch.getTime();

        long deadLine = endDateTimestamp + TimeUnit.DAYS.toSeconds(deadLineDaysValue);

        long currentTimeSeconds = TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis());
        boolean isReactive = type.equals("Reactive");
        return isReactive && currentTimeSeconds > deadLine;
    }

    public static boolean checkClassBasisDate(String classEndDate,TotalResponse<ParameterValueDTO.Info> parameterValues) {

        ParameterValueDTO.Info classBasisDate = parameterValues.getResponse().getData().stream().filter(p -> p.getCode().equals("classBasisDate")).findFirst().orElse(null);
        if (classBasisDate == null)
            return false;
        else
            return classEndDate.compareTo(classBasisDate.getValue()) >= 0;
    }

    public static String addSpaceToStringBySize(String a,int size){
        if (a.length() < size) {
            int space= (size -a.length()) / 2;
            StringBuilder text=new StringBuilder();
            text.append(" ".repeat(space));
            text.append(a);
            text.append(" ".repeat(space));
            return text.toString();
        } else {
            return a.substring(0, size)+"...";
        }
    }

    public static String changeDateDirection(String oldDate) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        Date newDate = sdf.parse(oldDate);
        sdf.applyPattern("dd/MM/yyyy");
        return sdf.format(newDate);
    }
}
