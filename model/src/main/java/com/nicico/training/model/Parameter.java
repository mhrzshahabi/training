package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
@Entity
@Table(name = "tbl_parameter")
public class Parameter extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_parameter_id")
    @SequenceGenerator(name = "seq_parameter_id", sequenceName = "seq_parameter_id", allocationSize = 1)
    private Long id;

    @Column(name = "c_title", nullable = false)
    private String title;

    @Column(name = "c_description")
    private String description;

    @OneToMany(mappedBy = "parameter", fetch = FetchType.LAZY)
    private List<ParameterValue> parameterValueList;
}
