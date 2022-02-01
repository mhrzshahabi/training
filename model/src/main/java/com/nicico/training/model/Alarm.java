package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id", callSuper = false)
@Entity
@Table(name = "tbl_alarm")
public class Alarm extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_alarm_id")
    @SequenceGenerator(name = "seq_alarm_id", sequenceName = "seq_alarm_id", allocationSize = 1)
    private Long id;

    @Column(name = "c_alarm_type_title_fa", nullable = false, length = 100)
    private String alarmTypeTitleFa;

    @Column(name = "c_alarm_type_title_en", nullable = false, length = 100)
    private String alarmTypeTitleEn;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_class_id", insertable = false, updatable = false)
    private Tclass tclass;

    @Column(name = "f_class_id")
    private Long classId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_session_id", insertable = false, updatable = false)
    private ClassSession session;

    @Column(name = "f_session_id")
    private Long sessionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher_id", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher_id")
    private Long teacherId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_student_id", insertable = false, updatable = false)
    private ClassStudent classStudent;

    @Column(name = "f_student_id")
    private Long studentId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_institute_id", insertable = false, updatable = false)
    private Institute institute;

    @Column(name = "f_institute_id")
    private Long instituteId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_training_place_id", insertable = false, updatable = false)
    private TrainingPlace trainingPlace;

    @Column(name = "f_training_place_id")
    private Long trainingPlaceId;

    @Column(name = "n_reservation_id")
    private Long reservationId;

    @Column(name = "n_target_record_id")
    private Long targetRecordId;

    @Column(name = "c_tab_name", length = 100)
    private String tabName;

    @Column(name = "c_page_address", length = 200)
    private String pageAddress;

    @Column(name = "c_alarm", length = 500, nullable = false)
    private String alarm;

    @Column(name = "n_detail_record_id")
    private Long detailRecordId;

    @Column(name = "c_sort_field", length = 50)
    private String sortField;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_class_id_conflict", insertable = false, updatable = false)
    private Tclass tclassConflict;

    @Column(name = "f_class_id_conflict")
    private Long classIdConflict;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_session_id_conflict", insertable = false, updatable = false)
    private ClassSession sessionConflict;

    @Column(name = "f_session_id_conflict")
    private Long sessionIdConflict;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_institute_id_conflict", insertable = false, updatable = false)
    private Institute instituteConflict;

    @Column(name = "f_institute_id_conflict")
    private Long instituteIdConflict;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_training_place_id_conflict", insertable = false, updatable = false)
    private TrainingPlace trainingPlaceConflict;

    @Column(name = "f_training_place_id_conflict")
    private Long trainingPlaceIdConflict;

    @Column(name = "n_reservation_id_conflict")
    private Long reservationIdConflict;
}
