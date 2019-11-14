package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_class_sessions")
public class ClassSessions extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "class_sessions_seq")
    @SequenceGenerator(name = "class_sessions_seq", sequenceName = "seq_class_sessions_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_class_id", insertable = false, updatable = false)
    private Tclass tclass;

    @NotNull
    @Column(name = "f_class_id")
    private Long idClass;

    @Column(name = "c_day_code")
    private String dayCode;

    @Column(name = "c_session_date")
    private String sessionDate;

    @Column(name = "c_session_start_hour")
    private String sessionStartHour;

    @Column(name = "c_session_end_hour")
    private String sessionEndHour;

    @Column(name = "c_id_session_type")
    private Integer idSessionType;

    @Column(name = "c_id_location")
    private Integer idLocation;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_id_teacher", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_id_teacher")
    private Long idTeacher;

    @Column(name = "c_session_state")
    private Integer sessionState;

    @Column(name = "c_description")
    private String description;
}
