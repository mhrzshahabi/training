package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import javax.persistence.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_attendance")
public class Attendance extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "attendance_seq")
    @SequenceGenerator(name = "attendance_seq", sequenceName = "seq_attendance_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_state")
    private String state;

    @Column(name = "c_description")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_student", insertable = false, updatable = false)
    private Student student;

    @Column(name = "f_student", nullable = false)
    private Long studentId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_session", insertable = false, updatable = false)
    private ClassSession session;

    @Column(name = "f_session", nullable = false)
    private Long sessionId;
}
