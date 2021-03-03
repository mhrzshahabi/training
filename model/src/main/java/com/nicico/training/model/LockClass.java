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
@Table(name = "tbl_lock_class")
public class LockClass extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "lock_class_seq")
    @SequenceGenerator(name = "lock_class_seq", sequenceName = "seq_lock_class_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @NotNull
    @Column(name = "class_id")
    private Long classId;

    @NotNull
    @Column(name = "class_code")
    private String classCode;

    @Column(name = "reason")
    private String reason;

}
