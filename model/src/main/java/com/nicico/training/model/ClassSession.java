package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_session")
public class ClassSession extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "session_seq")
    @SequenceGenerator(name = "session_seq", sequenceName = "seq_session_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_class_id", insertable = false, updatable = false)
    private Tclass tclass;

    @NotNull
    @Column(name = "f_class_id")
    private Long classId;

    @Column(name = "c_day_code")
    private String dayCode;

    @Column(name = "c_day_name")
    private String dayName;

    @Column(name = "c_session_date")
    private String sessionDate;

    @Column(name = "c_session_start_hour")
    private String sessionStartHour;

    @Column(name = "c_session_end_hour")
    private String sessionEndHour;

    @Column(name = "c_session_type_id")
    private Integer SessionTypeId;

    @Column(name = "c_session_type")
    private String sessionType;

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher_id", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher_id")
    private Long teacherId;

    @Column(name = "c_session_state")
    private Integer sessionState;

    @Column(name = "c_session_state_fa")
    private String sessionStateFa;

    @Column(name = "c_description")
    private String description;

    @Column(name = "b_teacher_attendance_permission")
    private Boolean teacherAttendancePermission;

    @OneToMany(mappedBy = "session", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
    private Set<Alarm> alarms;

    @OneToMany(mappedBy = "sessionConflict", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
    private Set<Alarm> alarmsConflict;

}
