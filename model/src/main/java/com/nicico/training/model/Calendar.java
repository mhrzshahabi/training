package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from tbl_official_calendar")
@DiscriminatorValue("tbl_official_calendar")
public class Calendar  {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "D_TIMESTAMP")
    private Date timestamp;

    @Column(name = "C_DATE_JALALI")
    private String dateJalali;

    @Column(name = "C_DATE_GRG")
    private String dateGrg;

    @Column(name = "C_DATE_HIJRI")
    private String dateHijri;

    @Column(name = "N_DAY_OF_WEEK")
    private Integer dayOfWeek;

    @Column(name = "N_IS_WEEKEND")
    private Boolean isWeekend;

    @Column(name = "N_DAY_OF_MONTH_JALALI")
    private Integer dayOfMonthJalali;

    @Column(name = "N_DAY_OF_YEAR_JALALI")
    private Integer dayOfYearJalali;

    @Column(name = "N_WEEK_OF_MONTH_JALALI")
    private Boolean weekOfMonthJalali;

    @Column(name = "C_MONTH_NAME_JALALI")
    private String monthNameJalali;

    @Column(name = "N_MONTH_JALALI")
    private Integer monthJalali;

    @Column(name = "N_YEAR_JALALI")
    private Integer yearJalali;

    @Column(name = "C_OCCASION_JALALI")
    private String occasionJalali;

    @Column(name = "N_IS_HOLIDAY_JALALI")
    private Boolean isHolidayJalali;

    @Column(name = "N_IS_LEAP_YEAR_JALALI")
    private Boolean isLeapYearJalali;

    @Column(name = "N_REMAINING_DAY_OF_YEAR_JALALI")
    private Integer remainingDayOfYearJalali;

    @Column(name = "N_DAY_OF_MONTH_GRG")
    private Integer dayOfMonthGrg;

    @Column(name = "N_DAY_OF_YEAR_GRG")
    private Integer dayOfYearGrg;

    @Column(name = "C_MONTH_NAME_GRG")
    private String monthNameGrg;

    @Column(name = "N_MONTH_GRG")
    private Integer monthGrg;

    @Column(name = "N_YEAR_GRG")
    private Integer yearGrg;

    @Column(name = "C_OCCASION_GRG")
    private String occasionGrg;

    @Column(name = "N_IS_HOLIDAY_GRG")
    private Boolean isHolidayGrg;

    @Column(name = "N_IS_LEAP_YEAR_GRG")
    private Boolean isLeapYearGrg;

    @Column(name = "N_REMAINING_DAY_OF_YEAR_GRG")
    private Integer remainingDayOfYearGrg;

    @Column(name = "N_WEEK_OF_MONTH_GRG")
    private Boolean weekOfMonthGrg;

    @Column(name = "N_DAY_OF_MONTH_HIJRI")
    private Integer dayOfMonthHijri;

    @Column(name = "N_DAY_OF_YEAR_HIJRI")
    private Integer dayOfYearHijri;

    @Column(name = "C_MONTH_NAME_HIJRI")
    private String monthNameHijri;

    @Column(name = "N_MONTH_HIJRI")
    private Integer monthHijri;

    @Column(name = "N_YEAR_HIJRI")
    private Integer yearHijri;

    @Column(name = "C_OCCASION_HIJRI")
    private String occasionHijri;

    @Column(name = "N_IS_HOLIDAY_HIJRI")
    private Boolean isHolidayHijri;

    @Column(name = "N_IS_LEAP_YEAR_HIJRI")
    private Boolean isLeapYearHijri;

    @Column(name = "N_REMAINING_DAY_OF_YEAR_HIJRI")
    private Integer remainingDayOfYearHijri;

    @Column(name = "N_WEEK_OF_MONTH_HIJRI")
    private Boolean weekOfMonthHijri;

    @Column(name = "N_SEASON")
    private Integer season;

    @Column(name = "N_DAY_OF_SEASON")
    private Integer dayOfSeason;

    @Column(name = "N_REMAINING_DAY_OF_SEASON")
    private Integer remainingDayOfSeason;

    @Column(name = "C_SEASON_NAME_FA")
    private String seasonNameFa;

    @Column(name = "C_SEASON_NAME_EN")
    private String seasonNameEn;

    @Column(name = "N_IS_HOLIDAY")
    private Boolean isHoliday;

    @Column(name = "N_HAS_53WEEKS")
    private Boolean has53weeks;

    @Column(name = "C_DAY_OF_WEEK_NAME_FA")
    private String dayOfWeekNameFa;

    @Column(name = "C_DAY_OF_WEEK_NAME_EN")
    private String dayOfWeekNameEn;

    @Column(name = "N_WEEK_OF_YEAR")
    private Integer weekOfYear;

    @Column(name = "C_COMMENT")
    private String comment;

    @Column(name = "C_OCCASION")
    private String occasion;


}
